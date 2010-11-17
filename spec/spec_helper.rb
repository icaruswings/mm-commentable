require 'rubygems'
require 'bundler/setup'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'fileutils'
require 'ostruct'
require 'log_buddy'

require 'rspec'

require 'mm-commentable'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def Doc(name=nil, &block)
  klass = Class.new do
    include MongoMapper::Document
    set_collection_name :test

    if name
      class_eval "def self.name; '#{name}' end"
      class_eval "def self.to_s; '#{name}' end"
    end
  end

  klass.class_eval(&block) if block_given?
  klass.collection.remove
  klass
end

def EDoc(name=nil, &block)
  klass = Class.new do
    include MongoMapper::EmbeddedDocument

    if name
      class_eval "def self.name; '#{name}' end"
      class_eval "def self.to_s; '#{name}' end"
    end
  end

  klass.class_eval(&block) if block_given?
  klass
end

log_dir = File.expand_path('../../log', __FILE__)
FileUtils.mkdir_p(log_dir) unless File.exist?(log_dir)

logger = Logger.new(log_dir + '/test.log')
LogBuddy.init(:logger => logger)

MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, :logger => logger)
MongoMapper.database = "mm-test-#{RUBY_VERSION.gsub('.', '-')}"
MongoMapper.database.collections.each { |c| c.drop_indexes }


RSpec.configure do |config|
end