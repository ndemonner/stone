require "fileutils"
require "stone/storage"
require "stone/serializers"
require "stone/actions"
require "stone/attributes"
require "stone/callbacks"
require "stone/relationships"
require "stone/validations"
require "stone/model"

module Stone
  class << self
    attr_accessor :storage, :serializer, :location, :models
    
    def setup!
      defaults
      FileUtils.mkdir(location + "data/") unless File.exist? location + "data/"
      load_models!
    end
    
    def teardown!
      FileUtils.rm_rf(location + "data/")
    end
    
    private
    
    def defaults
      self.storage ||= Storage::File
      self.location ||= Dir.pwd + "/"
      self.models ||= self.location + "models"
    end
    
    def load_models!
      Dir[self.models + "/*.rb"].each do |model|
        require model
      end
    end
    
  end
end