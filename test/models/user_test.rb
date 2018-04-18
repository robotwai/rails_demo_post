require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user  = User.new(name: "Example User",email: "user@example.com",password: "foobar",password_confirmation: "foobar")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = " "
  	assert_not @user.valid?
  end
  test "email should be present" do
  	@user.email = " "
  	assert_not @user.valid?
  end
  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USEr@foo.COM A_US@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject valid addresses" do
    valid_addresses = %w[userexample.com A_US@fo o.bar.org first.last@fo o.jp alice+bob@baz.c1n]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert_not @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user  =@user.dup
    duplicate_user.email  =@user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "save email must be downcase" do
    mixed_email = "FOX@Example.coM"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end

  test "password should be present (noblank)" do
    @user.password = @user.password_confirmation = " "*6
    assert_not @user.valid?
  end
end
