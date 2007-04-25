require 'test/unit'

require 'rubygems'
require 'active_support'
require 'active_record'

$LOAD_PATH << File.dirname(__FILE__) + '/../lib/'
require File.dirname(__FILE__) + '/../init.rb'

module Predicates
  class Required < Base
  end
  class Email < Base
  end
  class Length < Base
  end
  class PhoneNumber < Base
  end
end

class FakeModel < ActiveRecord::Base
  abstract_class = true
end
