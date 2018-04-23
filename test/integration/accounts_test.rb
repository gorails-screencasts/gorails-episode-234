require 'test_helper'

class AccountsTest < ActionDispatch::IntegrationTest
  test "middleware" do
    ActionDispatch::IntegrationTest.app = AccountMiddleware.new(ActionDispatch::IntegrationTest.app)

    account = accounts(:one)
    get "/#{account.id}/posts", env: { "REQUEST_PATH" => "/#{account.id}/posts" }

    assert_response :success
  end
end
