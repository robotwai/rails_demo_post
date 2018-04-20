require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path,params: {
  			user: {
  				name: "",
  				email: "user@invalid",
  				password: "fo",
  				password_confirmation: "ba"
  			}
  		}
  	end
  	assert_template 'users/new'
  	
  end

end
