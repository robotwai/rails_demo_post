require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@relationship = Relationship.new(follower_id: users(:michael).id,followed_id: users(:archer).id)
  end

  test "should be valid" do
  	assert @relationship.valid?
  end
end
