$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'stone'
require 'spec'
require 'spec/autorun'

require 'models/student'
require 'models/teacher'
require 'models/essay'
require 'models/grade'

Stone.storage = Stone::Storage::File
Stone.location = File.dirname(__FILE__) + "/"
Stone.serializer = Stone::Serializers::Yaml