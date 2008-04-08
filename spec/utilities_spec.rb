require File.join(File.dirname(__FILE__), "spec_helper")

describe Stone::Utilities do
  it "should import data from a single sql file and create a new datastore"
  it "should import data from a single yaml file and create a new datastore"
  it "should export to a single sql file from an existing datastore"
  it "should export to a single yaml file from an existing datastore"
  it "should backup a datastore (in the form of an archive) to a given path"
end