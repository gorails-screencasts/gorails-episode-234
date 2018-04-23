require 'test_helper'

class AccountMiddlewareTest < ActiveSupport::TestCase
  setup do
    Current.account = nil
  end

  test "loads the account" do
    account      = accounts(:one)
    account_path = "/#{account.id}"
    path         = "/posts"
    full_path    = account_path + path

    app        = ->(env) { [200, env, "app"] }
    middleware = AccountMiddleware.new(app)
    response   = Rack::MockRequest.new(middleware).get(full_path, "REQUEST_PATH" => full_path)

    assert_equal Current.account, account
    assert_equal account_path, response["SCRIPT_NAME"]
    assert_equal path, response["PATH_INFO"]
    assert_equal path, response["REQUEST_PATH"]
    assert_equal path, response["REQUEST_URI"]
  end

  test "redirect if it fails to load the account" do
    account_path = "/12345"
    path         = "/posts"
    full_path    = account_path + path

    app        = ->(env) { [200, env, "app"] }
    middleware = AccountMiddleware.new(app)
    response   = Rack::MockRequest.new(middleware).get(full_path, "REQUEST_PATH" => full_path)

    assert_equal "/", response.headers["Location"]

    assert_nil Current.account
    assert_nil response["SCRIPT_NAME"]
    assert_nil response["PATH_INFO"]
    assert_nil response["REQUEST_PATH"]
    assert_nil response["REQUEST_URI"]
  end
end
