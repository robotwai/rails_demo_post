require 'test_helper'

class DestoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @destory = destories(:one)
  end

  test "should get index" do
    get destories_url
    assert_response :success
  end

  test "should get new" do
    get new_destory_url
    assert_response :success
  end

  test "should create destory" do
    assert_difference('Destory.count') do
      post destories_url, params: { destory: { Person: @destory.Person } }
    end

    assert_redirected_to destory_url(Destory.last)
  end

  test "should show destory" do
    get destory_url(@destory)
    assert_response :success
  end

  test "should get edit" do
    get edit_destory_url(@destory)
    assert_response :success
  end

  test "should update destory" do
    patch destory_url(@destory), params: { destory: { Person: @destory.Person } }
    assert_redirected_to destory_url(@destory)
  end

  test "should destroy destory" do
    assert_difference('Destory.count', -1) do
      delete destory_url(@destory)
    end

    assert_redirected_to destories_url
  end
end
