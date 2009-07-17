require "rubygems"
require "ruby-debug"
require "uri"

class Domain
  
  DOMAIN_URI = /^\w[\w\.\-\_]+\.[\w\.]{2,7}$/i.freeze
  
  # Keep it simple
  attr_accessor :domain

  # Class methods
  #===========================================================================
  
  # Return all of the banned domains
  def self.banned_domains
    @@banned_domains ||= {}
  end
  
  # Return true if this is a known spam domain, false otherwise
  def self.banned?(suspect_domain)
    banned_domains[normalized_domain(suspect_domain)].eql?(true)
  end

  # Ban a domain
  def self.ban!(domain)
    banned_domains[normalized_domain(domain)] = true
  end

  # Return a normalized URL
  def self.normalized_domain(domain)
    # Support protocols/ports/etc
    (domain =~ DOMAIN_URI) ? domain : URI.parse(domain).host
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
  
  # Ban this specific domain instance
  def ban!
    Domain.ban!(domain)
  end

  # Blacklists
  #===========================================================================
  
  # Load existing known bad spammer domains, returns number of domains loaded
  # @todo make this pull from a dynamic source on the net
  def self.load_blacklist(absolute_path = nil)
    absolute_path = default_blacklist_path if !absolute_path
    
    raise "unable to find blacklist data file: #{ absolute_path }" \
      unless File.exists?(absolute_path)
    
    # keep for the total we'll return
    existing_size = banned_domains.size
    
    # Grab the domains, squash the newlines, ignore comments and blank lines
    File.readlines(absolute_path).each{ |d| Domain.ban!(d.chomp) unless d =~ /(^\#|^\s+$)/ }

    puts "loaded #{ banned_domains.size } banned domains." if $DEBUG
    
    return banned_domains.size - existing_size
  end
  
  # Path to the default blacklist
  def self.default_blacklist_path
    File.expand_path(File.join(__FILE__, "..", "..", "data", "blacklist.txt"))
  end
  
end
