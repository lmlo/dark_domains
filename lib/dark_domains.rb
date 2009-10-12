$:.push File.join(File.dirname(__FILE__), '..', 'lib')

# Version
module DarkDomains
  VERSION = '0.0.1'
end

# Easy require
require "dark_domains/models/domain.rb"