require 'fileutils'
require 'lib/stone/core_ext/string'
require 'rubygems'
require 'validatable'
require 'english/inflect'
require 'facets'
require 'yaml'
require 'fastercsv'
require 'lib/stone/resource'
require 'lib/stone/utilities'

STONE_ROOT = Dir.pwd

$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Stone
  class << self
    
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
    
    # Creates or updates a datastore at +path+
    # === Parameters
    # +path+<String>:: 
    #   Path to create datastore (usually an application's root)
    # +resources+<Array>:: A list of resources that exist for the application
    def build_datastore(path, resources)
      FileUtils.mkdir(path/"datastore") unless File.exists?(path/"datastore")
      resources.each do |resource|
        name = File.basename(resource).gsub(".rb", "").pluralize
        unless File.exists? path/"datastore"/name
          FileUtils.mkdir(path/"datastore"/name)
        end
      end
    end
    
  end # self
end # Stone