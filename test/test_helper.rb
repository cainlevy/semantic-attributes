require 'test/unit'

require 'rubygems'
require 'active_record'
require 'active_support'

$LOAD_PATH << File.dirname(__FILE__) + '/../lib/'
require File.dirname(__FILE__) + '/../init.rb'

class FakeModel < ActiveRecord::Base
  abstract_class = true
  def self.columns
    []
  end
end
