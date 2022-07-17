require 'application_system_test_case'

class ArticlesTest < ApplicationSystemTestCase
  setup do
    @article = articles(:one)
  end

  test 'visiting the index' do
    visit articles_url
    assert_selector 'h1', text: 'Articles'
  end

  test 'show article and scrape button if article was never scraped' do
    visit articles_url
    assert_selector 'h1', text: 'Articles'

    click_on @article.header
    assert_selector 'h1', text: 'Articles', count: 0
    assert_text @article.header
    assert_selector '.scrape_btn', count: 1
    assert_selector '.update_tags_btn', count: 0
  end

  test 'show article and updated tags button if article was already scraped' do
    visit articles_url
    assert_selector 'h1', text: 'Articles'

    click_on articles(:two).header
    assert_selector 'h1', text: 'Articles', count: 0
    assert_text articles(:two).header
    assert_selector '.scrape_btn', count: 0
    assert_selector '.update_tags_btn', count: 1
  end

  # Removed this functionality
  # test 'should create article' do
  #   visit articles_url
  #   click_on 'New article'

  #   fill_in 'Body', with: 'ChikiBody'
  #   fill_in 'Header', with: 'Chikiheader'
  #   fill_in 'Url', with: 'ChikiUrl'
  #   click_on 'Create Article'

  #   assert_text 'Article was successfully created'
  #   click_on 'Back'
  # end

  test 'should update Article' do
    visit article_url(@article)
    click_on 'Edit this article', match: :first

    fill_in 'Body', with: @article.body
    fill_in 'Header', with: @article.header
    fill_in 'Url', with: @article.url
    click_on 'Update Article'

    assert_text 'Article was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Article' do
    visit article_url(@article)
    click_on 'Destroy this article', match: :first

    assert_text 'Article was successfully destroyed'
  end
end
