require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha'
require 'mongo_mapper'
require 'active_support'
require 'mongo_mapper_sluggable'

module MongoMapper
  module Connection
    def connect(environment, options = { })
      env                    = config_for_environment environment
      MongoMapper.connection = Mongo::Connection.multi(env["replica_sets"])
      MongoMapper.database   = env["database"]
    end
  end
end

mongo_config = { "test" => { "replica_sets" => [ [ "localhost", 27017 ], [ "localhost", 27018 ] ],
                             "database"     => "slug_test" } }

MongoMapper.setup mongo_config, "test"

class TestEmbeddableDocument < Test::Unit::TestCase
  include Shoulda
  
  class ::Fnord
    include MongoMapper::Document
    include MongoMapper::Sluggable
    
    key :name
    
    slugged_attr :name
  end
  
  def setup
    MongoMapper.database.collections.each do |collection|
      collection.remove
    end
  end
  
  should "create a slugged version of a key" do
    fnord = Fnord.new :name => "I have seen the fnords."
    fnord.save
    assert_equal "i-have-seen-the-fnords", fnord.slug
  end
  
  should "allow non unique slugs if the option is set" do
    Fnord.expects(:allow_non_unique_slug?).once.returns(true)
    fnord1 = Fnord.new :name => "23 skidoo"
    fnord2 = Fnord.new :name => "23 skidoo"
    
    fnord1.save
    fnord2.save
    
    assert_equal "23-skidoo", fnord1.slug
    assert_equal "23-skidoo-#{fnord2.id}", fnord2.slug
  end
  
  should "cause a validation error if the slug has been taken and non unique slugs are not allowed" do
    fnord1 = Fnord.new :name => "23 skidoo"
    fnord2 = Fnord.new :name => "23 skidoo"
    
    assert fnord1.save, "fnord 1 is valid"
    assert !fnord2.save, "fnord 2 should not be valid"
    
    assert_equal "has already been taken", fnord2.errors[:name].first
  end
  
  should "give the slug as the to_param value" do
    fnord = Fnord.new :name => "23 skidoo"
    assert fnord.save, "fnord 1 is valid"
    
    assert_equal fnord.slug, fnord.to_param
    
  end
  
end
