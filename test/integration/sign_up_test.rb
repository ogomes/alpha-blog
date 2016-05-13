require 'test_helper'

class SignUpTest < ActionDispatch::IntegrationTest
  
  test 'User must be signed up' do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: {username: "bobo", email: "bobo@gugu.com", password: "bobo"}
    end
    assert_template 'users/show'
    assert_match 'bobo', response.body
  end
  
  
  test "all validations for sign up resulting in failure" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'Category.count' do
      post users_path, user: {username:"", email: "", password: ""}
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
    assert_match '5 errors', response.body
  end
  
end