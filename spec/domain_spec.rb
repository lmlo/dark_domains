require File.dirname(__FILE__) + '/spec_helper'

describe Domain do

  context "(class)" do
    
    before do
      @valid_domain  = "socialface.com"
      @banned_domain = "myspace.com"
      
      Domain.ban!(@banned_domain)
    end
    
    it "should have a #banned_domains method" do
      Domain.should respond_to(:banned_domains)
    end
    
    it "should have a #ban! method" do
      Domain.should respond_to(:ban!)
    end
    
    it "should have a #banned? method" do
      Domain.should respond_to(:banned?)
    end
    
    it "should return false for valid or unknown domains" do
      Domain.banned?(@valid_domain).should be_false
    end
  
    it "should return true for known spam domains" do
      Domain.banned?(@banned_domain).should be_true
    end
    
    it "should ignore protocol information from domains" do
      Domain.banned?("http://#{ @banned_domain }").should be_true
    end
    
  end

  context "(blacklists)" do
    
    it "should load an existing default blacklist" do
      lambda do
        begin
          Domain.load_blacklist
        end
      end.should change(Domain.banned_domains, :size)
    end
    
    it "should have the path to a default blacklist" do
      File.exists?(Domain::default_blacklist_path).should be_true
    end
    
  end
  
  context "(instance)" do
    
    before do
      @valid_domain  = Domain.new("socialface.com")
      @banned_domain = Domain.new("myspace.com")
      
      @banned_domain.ban!
    end
    
    it "should return false if not banned" do
      @valid_domain.banned?.should be_false
    end
    
    it "should return false if not banned" do
      @banned_domain.banned?.should be_true
    end
    
  end
  
end