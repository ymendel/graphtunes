$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rexml/document'

module Graphtunes
  class << self
    def import(file)
      raise TypeError, "'#{file}' is not a file" unless File.file?(file)
      get_tracks(File.read(file))
    end
    
    def get_tracks(data)
      doc = REXML::Document.new(data)
      
      tracks = nil
      doc.elements.each('plist/dict/key') do |el|
        if el.text == 'Tracks'
          tracks = el.next_element
        end
      end
      
      raise 'No track information found' unless tracks
      
      get_track_list(tracks)
    end
  end
end
