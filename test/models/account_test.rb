require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "middleware" do
    account    = accounts(:one)
    path       = "/#{account.id}/posts"

    middleware = AccountMiddleware.new(->(env) { [200, env, "app"] })
    response = Rack::MockRequest.new(middleware).get(path, "REQUEST_PATH" => path)

    assert_equal Current.account, account
  end
end
