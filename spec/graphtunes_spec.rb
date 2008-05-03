require File.dirname(__FILE__) + '/spec_helper.rb'

describe Graphtunes do
  it 'should import data' do
    Graphtunes.should respond_to(:import)
  end
  
  describe 'importing data' do
    before :each do
      @filename = 'blah'
      File.stubs(:file?).returns(true)
      @data = stub('file data')
      File.stubs(:read).with(@filename).returns(@data)
      Graphtunes.stubs(:get_track_list)
    end
    
    it 'should require a filename' do
      lambda { Graphtunes.import }.should raise_error(ArgumentError)
    end
    
    it 'should accept a filename' do
      lambda { Graphtunes.import(@filename) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require the argument to be a real file' do
      File.stubs(:file?).with(@filename).returns(false)
      lambda { Graphtunes.import(@filename) }.should raise_error(TypeError)
    end
    
    it 'should require the argument to be a real file' do
      File.stubs(:file?).with(@filename).returns(true)
      lambda { Graphtunes.import(@filename) }.should_not raise_error(TypeError)
    end
    
    it 'should read the contents of the file' do
      File.expects(:read).with(@filename)
      Graphtunes.import(@filename)
    end
    
    it 'should get the track list from the file' do
      Graphtunes.expects(:get_track_list).with(@data)
      Graphtunes.import(@filename)
    end
  end
  
  it 'should get the track list' do
    Graphtunes.should respond_to(:get_track_list)
  end
  
  describe 'getting the track list' do
    before :each do
      @data = %q[
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>Tracks</key>
      	  <dict>
          </dict>
        </dict>
        </plist>
      ]
      @tracks = stub('tracks')
      Graphtunes.stubs(:get_tracks).returns(@tracks)
      @order = stub('order')
      Graphtunes.stubs(:get_track_order).returns(@order)
      Graphtunes.stubs(:order_tracks)
    end
    
    it 'should require data' do
      lambda { Graphtunes.get_track_list }.should raise_error(ArgumentError)
    end
    
    it 'should accept data' do
      lambda { Graphtunes.get_track_list(@data) }.should_not raise_error(ArgumentError)
    end
    
    it 'should require there to be a notifier of track data' do
      @data = %q[
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>Major Version</key><integer>1</integer>
        </dict>
        </plist>
      ]
      lambda { Graphtunes.get_track_list(@data) }.should raise_error
    end
    
    it 'should require there to be track data' do
      @data = %q[
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>Tracks</key>
        </dict>
        </plist>
      ]
      lambda { Graphtunes.get_track_list(@data) }.should raise_error
    end
    
    
    it 'should accept data that includes track data' do
      @data = %q[
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>Tracks</key>
      	  <dict>
          </dict>
        </dict>
        </plist>
      ]
      lambda { Graphtunes.get_track_list(@data) }.should_not raise_error
    end
    
    it 'should get the tracks' do
      Graphtunes.expects(:get_tracks)
      Graphtunes.get_track_list(@data)
    end
    
    it 'should get the track ordering' do
      Graphtunes.expects(:get_track_order)
      Graphtunes.get_track_list(@data)
    end
    
    it 'should order the tracks' do
      Graphtunes.expects(:order_tracks).with(@tracks, @order)
      Graphtunes.get_track_list(@data)
    end
    
    it 'should return the ordered tracks' do
      ordered = stub('ordered tracks')
      Graphtunes.stubs(:order_tracks).returns(ordered)
      Graphtunes.get_track_list(@data).should == ordered
    end
  end
end
