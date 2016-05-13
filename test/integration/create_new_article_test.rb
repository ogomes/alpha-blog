require 'test_helper'

class CreateNewArticleTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create(username:"tester", email:"tester@example.com", password:"test")
  end
  
  test "get new article form and create article" do
    sign_in_as(@user,"test")
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post_via_redirect articles_path, article: {title:"article test", description: "description test", user_id:"@user.id"}
    end
    assert_template 'articles/show'
    assert_match "article test", response.body
  end
  
  test "all validations for article resulting in failure" do
    sign_in_as(@user,"test")
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, article: {title:"", description: "", user_id:""}
    end
    assert_template 'articles/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
    assert_match "4 errors", response.body
  end

end