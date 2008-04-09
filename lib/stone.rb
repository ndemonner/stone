require 'fileutils'
require 'lib/stone/core_ext/string'
require 'rubygems'
require 'validatable'
require 'english/inflect'
require 'facets'
require 'yaml'
require 'fastercsv'
require 'lib/stone/association_map'
require 'lib/stone/data_store'
require 'lib/stone/resource'
require 'lib/stone/utilities'

STONE_ROOT = Dir.pwd

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Stone
  class << self
    
    @@dir ||= ""
    
    # See Stone::Utilities.backup
    def backup(from_path, to_path = nil)
      Stone::Utilities.backup(from_path, to_path)
    end
    
    # See Stone::Utilities.export
    def export(path, to_format)
      Stone::Utilities.export(path, to_format)
    end
    
    # See Stone::Utilities.import
    def import(path, type)
      Stone::Utilities.import(path, type)      
    end
    
    # See Stone::Utilities.metrics_for
    def metrics_for(path)
      Stone::Utilities.metrics_for(path)
    end
    
    def local_dir=(value) #:nodoc:
      @@dir = value
    end
    
    # Provides the directory path to the local (app-specific) datastore
    def local_dir
      @@dir
    end
    
    # For spec stuff only
    def empty_datastore
      if File.exists? STONE_ROOT/"sandbox_for_specs/datastore"
        FileUtils.rm_rf STONE_ROOT/"sandbox_for_specs/datastore"
      end
    end
    
    # Creates or updates a datastore at +path+
    # === Parameters
    # +path+<String>:: 
    #   Path to create or update datastore (usually an application's root)
    # +resources+<Array>:: A list of resources that exist for the application
    def build_datastore(path, resources)
      self.local_dir = path/"datastore"
      FileUtils.mkdir(self.local_dir) unless File.exists?(self.local_dir)
      resources.each do |resource|
        name = File.basename(resource).gsub(".rb", "").pluralize
        unless File.exists? self.local_dir/name
          FileUtils.mkdir(self.local_dir/name)
        end
      end
    end
    
  end # self
end # Stone