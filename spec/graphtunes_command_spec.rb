require File.dirname(__FILE__) + '/spec_helper.rb'

describe 'graphtunes command' do
  def run_command(*args)
    Object.const_set(:ARGV, args)
    begin
      eval File.read(File.join(File.dirname(__FILE__), *%w[.. bin graphtunes]))
    rescue SystemExit
    end
  end
  
  before :all do
    path = File.join(File.dirname(__FILE__), *%w[.. bin])
    ENV['PATH'] = [path, ENV['PATH']].join(':')
  end
  
  before :each do
    Graphtunes.stubs(:process)
  end
  
  it 'should exist' do
    lambda { run_command('blah') }.should_not raise_error(Errno::ENOENT)
  end
  
  it 'should require a filename' do
    self.expects(:puts) { |text|  text.match(/usage.+filename/i) }
    run_command
  end
  
  it 'should pass the filename to Graphtunes for processing' do
    Graphtunes.expects(:process).with('blah')
    run_command('blah')
  end
end
