require "rubygems"
require "ruby-debug"

class Domain
  
  DOMAIN_URI = /^[a-z0-9][a-z0-9\.\-\_]+$/i.freeze
  
  # Keep it simple
  attr_accessor :domain

  # Class methods
  #===========================================================================
  
  # Return all of the banned domains
  def self.banned_domains
    @@banned_domains ||= []
  end
  
  # Return true if this is a known spam domain, false otherwise
  def self.banned?(suspect_domain)
    banned_domains.include?(suspect_domain)
  end

  # Ban a domain
  def self.ban!(domain)
    banned_domains << domain unless banned_domains.include?(domain)
  end

  # Instance
  #===========================================================================

  # Create a domain instance
  def initialize(domain)
    self.domain = domain
  end

  # Return true if we are a banned domain
  def banned?
    Domain.banned?(domain)
  end

  def ban!
    Domain.ban!(domain)
  end
  
  #===========================================================================

  # Load existing known bad spammer domains
  def self.load_known_banned_domains
    # @todo make this pull from a dynamic source on the net or something
    load_path = File.expand_path(File.join("lib", "donuts", "data", "spammers.txt"))
    raise "unable to find spammers.txt data file: #{ load_path }" unless File.exists?(load_path)
    
    # Grab the domains and squash the newlines, 
    File.readlines(load_path).each{ |d| Domain.ban!(d.chomp) if d =~ DOMAIN_URI }

    puts "loaded #{ banned_domains.size } banned domains."
    
    return banned_domains.size
  end
  
end
