$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Graphtunes
  class << self
    def import(file)
      raise TypeError, "'#{file}' is not a file" unless File.file?(file)
      File.read(file)
    end
  end
end
