module ArticlesHelper
  def article_header(article)
    content = ''
    if controller_name == 'articles' && action_name == 'index'
      link_to article_path(article), data: { turbo: false } do
        "<p class='text-l py-3 px-14 my-2 bg-white drop-shadow rounded border-l-4 border-white hover:border-indigo-500'>#{article.header}</p>".html_safe
      end
      # content << html
    elsif controller_name == 'articles' && action_name == 'show'
      html = "<h1 class='py-3 text-center px-14 rounded mb-4 bg-blue-100 drop-shadow'>#{article.header}</h1>"
      content << html
      content.html_safe
    end
  end

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

    button_to 'Scrape this article', article_path(article), class: 'scrape_btn', method: :patch, data: { turbo: false },
                                                            params: { 'full_scrape' => true }
  end

  def update_tags_btn(article)
    return unless controller_name == 'articles' && action_name == 'show' && article.browsed

    button_to 'Update tags', article_path(article), class: 'update_tags_btn', method: :patch, data: { turbo: false },
                                                    params: { 'get_tags' => true }
  end

  def article_body(article)
    return unless controller_name == 'articles' && action_name == 'show' && article.browsed

    html = article.body.split("\n").map { |paragraph| '<p>' + paragraph + '</p>' }.join
    ("<div class='article_body'>" + html + '</div>').html_safe
  end
end
