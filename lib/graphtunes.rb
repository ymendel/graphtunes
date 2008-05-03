$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rexml/document'
require 'gruff'

module Graphtunes
  class << self
    def process(file)
      data = import(file)
      graph(data, file.chomp('.xml') + '.png')
    end
    
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
      order  = get_track_order(doc)
      order_tracks(tracks, order)
    end
    
    def get_tracks(data)
      track_data = {}
      data.elements.each('key') do |key|
        track_id = key.text
        track = key.next_element
        track_data[track_id] = extract_track_data(track)
      end
      track_data
    end
    
    def extract_track_data(data)
      track_data = {}
      data.elements.each('key') do |key|
        field = key.text
        if extraction_fields.include?(field)
          value = key.next_element.text
          value = value.to_i if field == 'BPM'
          track_data[field] = value
        end
      end
      track_data
    end
    
    def get_track_order(data)
      playlists = nil
      data.elements.each('plist/dict/key') do |el|
        if el.text == 'Playlists'
          playlists = el.next_element
        end
      end
      
      items = nil
      playlists.elements.each('dict/key') do |el|
        if el.text == 'Playlist Items'
          items = el.next_element
        end
      end
      
      order = []
      
      items.elements.each('dict') do |dict|
        dict.elements.each('key') do |key|
          if key.text == 'Track ID'
            order.push(key.next_element.text)
          end
        end
      end
      
      order
    end
    
    def order_tracks(tracks, order)
      ordered = []
      order.each do |i|
        ordered.push(tracks[i])
      end
      ordered
    end
    
    def graph(data, file)
      graph = Gruff::Line.new
      graph.data('BPM', data.collect { |t|  t['BPM'] })
      graph.hide_dots = true
      graph.write(file)
    end
    
    private
    
    def extraction_fields
      ['Track ID', 'Name', 'Artist', 'Album', 'BPM']
    end
  end
end
