require "application_system_test_case"

class AccountMiddlewaresTest < ApplicationSystemTestCase
  test "loads account correctly" do
    account = accounts(:one)

    visit posts_url(script_name: "/#{account.id}")

    assert_selector "a", text: account.name
    assert_selector "h1", text: "Posts"
  end

  test "cannot find the account" do
    visit posts_url(script_name: "/123456789")
    assert_selector "a", text: "MyApp"
    assert_equal "/", current_path
  end
end
