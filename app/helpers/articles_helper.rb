module ArticlesHelper
  def show_article_tags(article)
    content = ''
    if controller_name == 'articles' && action_name == 'show'
      html = ''
      article.tags.each do |tag|
        html += "<div class='btn-tag'>#{tag.name}</div>"
      end

      content << html
    end
    content.html_safe
  end

  def scrape_btn(article)
    return unless controller_name == 'articles' && action_name == 'show' && !article.browsed
      button_to 'Scrape this article', article_path(article), class: "scrape_btn" ,method: :patch, data: { turbo: false },
                                                              params: { 'full_scrape' => true }
  end

  def update_tags_btn(article)
    return unless controller_name == 'articles' && action_name == 'show' && article.browsed
    button_to 'Update tags', article_path(article), class: "update_tags_btn", method: :patch, data: { turbo: false },
                                                              params: { 'get_tags' => true }
  end

  def article_body(article)
    article.body if controller_name == 'articles' && action_name == 'show' && article.browsed
  end

end
