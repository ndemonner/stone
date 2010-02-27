require "rubygems"

require "stone/ext/fixnum"
require "stone/resource"
require "stone/serializer"
require "stone/map"

module Stone
  class << self
    attr_accessor :db
    attr_accessor :map
    attr_accessor :serializer
    attr_accessor :compatibility
    
    def setup!
      yield(self) if block_given?
      
      @db ||= Pathname.new(Dir.pwd + "/db/")
      @db = Pathname.new(@db) unless @db.is_a?(Pathname)
      @db.mkdir unless @db.exist?
      
      @compatibility ||= []
      @serializer ||= Stone::Serializer::YAML.new
      
      @map = Stone::Map.new(Stone.db)
    end
    
    def teardown!
      @db.rmtree
      @db, @serializer, @map, @compatibility = nil
    end
  end
end