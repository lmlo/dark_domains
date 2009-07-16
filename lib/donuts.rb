$:.push File.join(File.dirname(__FILE__), '..', 'lib')

# Version
module Donuts
  VERSION = '0.0.1'
end

# Easy require
require "donuts/models/domain.rb"