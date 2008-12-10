require 'fileutils'
require 'rubygems'
require 'validatable'
require 'english/inflect'
require 'facets'
require 'yaml'

require File.expand_path(File.dirname(__FILE__) + '/stone/core_ext/string')
require File.expand_path(File.dirname(__FILE__) + '/stone/core_ext/symbol')
require File.expand_path(File.dirname(__FILE__) + '/stone/core_ext/datetime')
require File.expand_path(File.dirname(__FILE__) + '/stone/query')
require File.expand_path(File.dirname(__FILE__) + '/stone/data_store')
require File.expand_path(File.dirname(__FILE__) + '/stone/callbacks')
require File.expand_path(File.dirname(__FILE__) + '/stone/resource')

STONE_ROOT = Dir.pwd

module Stone
  class << self

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
    def start(path, resources, framework = nil)
      DataStore.local_dir = path/"datastore"

      # create the datastore dir unless it exists
      FileUtils.mkdir_p(DataStore.local_dir) unless File.exists?(DataStore.local_dir)

      # create a .stone_metadata that contains the resource locations
      # for Stone::Utilities to use
      File.open(DataStore.local_dir/".stone_metadata", "w") do |out|
        YAML.dump({:rsrc_path => File.dirname(resources.first)}, out)
      end unless File.exists?(DataStore.local_dir/".stone_metadata")

      # load each resource unless a framework has already done it
      resources.each do |resource|
        require resource unless framework == :merb || framework == :rails
        name = File.basename(resource,".rb").pluralize
        unless File.exists? DataStore.local_dir/name
          FileUtils.mkdir_p(DataStore.local_dir/name)
        end
      end
    end
  end # self
end # Stone