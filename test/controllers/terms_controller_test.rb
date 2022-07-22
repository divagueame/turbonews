require 'test_helper'

class TermsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:four)
  end

  test 'should create term from an article' do
    assert_difference('Term.count') do
      patch terms_url(@article.id), params: { article_id: @article.id }
    end

    assert_response 204
  end

  test 'should not create term from an article if already exists' do
    @existing_article = articles(:two)
    assert_no_difference('Term.count') do
      patch terms_url(@existing_article.id), params: { article_id: @existing_article.id }
    end

    assert_response 204
  end

  test 'should create all terms from an articles' do
    assert_difference('Term.count') do
      post terms_find_all_terms_path, params: { update_all_terms: true }
    end

    assert_equal '1 new terms added.', flash[:notice]
    assert_response 302
  end
end
