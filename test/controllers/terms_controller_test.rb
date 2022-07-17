require 'test_helper'

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:four)
  end

  test 'should create term from an article' do
    assert_difference('Term.count') do
      patch terms_url(@article.id), params: { article_id: @article.id }
    end

    assert_response 204
  end
end
