module ArticlesHelper

    def show_article_tags(article)
        content = ''
        if controller_name == 'articles' && action_name == 'show'
            html = ""
            article.tags.each do |tag|
                html += "<h1>#{tag.name}</h1>"
            end
            
          content << html
        end
        content.html_safe
      end
      
end
