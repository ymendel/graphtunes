$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rexml/document'

module Graphtunes
  class << self
    def import(file)
      raise TypeError, "'#{file}' is not a file" unless File.file?(file)
      get_track_list(File.read(file))
    end
    
    def get_track_list(data)
      doc = REXML::Document.new(data)
      
      track_list = nil
      doc.elements.each('plist/dict/key') do |el|
        if el.text == 'Tracks'
          track_list = el.next_element
        end
      end
      
      raise 'No track list information found' unless track_list
      
      tracks = get_tracks(track_list)
      order  = get_track_order
      order_tracks(tracks, order)
    end
  end
end
