require 'test_helper'

class ChefTest < ActiveSupport::TestCase
    
    def setup
      @chef = Chef.new(chefname: "john", email: "john@example.com") 
    end 
    
    test "chef should be valid" do 
       assert @chef.valid?
    end 
    
    test "chef should have name present" do
      @chef.chefname = ""
      assert_not @chef.valid?
    end 
    
    test "email must be present" do
        @chef.email = ""
        assert_not @chef.valid? 
    end 
    
    test 'chef should have maximum name legnth' do
        @chef.chefname = "a" * 101 + "@example.org"
        assert_not @chef.valid? 
    end 
    
    test "email must be unique" do
        
        dup_chef  = @chef.dup
        dup_chef.email = @chef.email.upcase
        @chef.save 
        assert_not dup_chef.valid? 
    end 
        
        
    test "email must be valid addressess" do 
        valid_addressess = %w[user@eee.com R_TDD-DS@eee.hello.org user@example.com first.last@eem.au laura+joe@mark.cm]
        valid_addressess .each do |va|
        @chef.email = va 
        assert @chef.valid?, '#{va.inspect} ahould be valid' 
        end 
    end 
    
=begin    test "invalid email addressess"
        invalid_adddressess = %w[user@example,com user_at_eee.org user.name@example. eee@i_am_.com foo@eee+aa.com]
        invalid_adddressess .each do |ia|
            @chef.email= ia
        assert_not @chef.valid?, '#{ia.inspect} ahould be valid'
=end      end 
end 