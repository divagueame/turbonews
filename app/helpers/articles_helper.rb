module ArticlesHelper

    def show_article_tags(article)
        content = ''
        if controller_name == 'articles' && action_name == 'show'
            html = ""
            article.tags.each do |tag|
                html += "<div class='btn-tag'>#{tag.name}</div>"
            end
            
          content << html
        end
        content.html_safe
      end
      
end
