module Extracter
  extend ActiveSupport::Concern

  included do
    # Creates dictionary of the article body
    # Min allows to limit the minimum amount of times a word needs to be found to be included in the results
    def get_article_body_dictionary(article, min = 0)
      words_count = {}
      words_array = article.body.downcase.split(/[,\s]+/).select { |word| word.length >= 4 }
      words_array.each { |word| words_count[word] ? words_count[word] += 1 : words_count[word] = 1 }

      words_count = words_count.reject { |_k, v| v < min } if min > 0

      words_count
    end

    def valid_url?(url)
      (url[0, 3] === 'htt') || (url[0, 3] === 'www') ? true : false
    end

    # Returns a hash with a counter of terms ocurrences
    def get_article_tags(article)
      tags = {}
      dictionary = get_article_body_dictionary(article)
      terms = get_article_terms(dictionary.keys)
      terms.each do |term|
        next unless dictionary.keys.include?(term.name)

        term.tags.each do |tag|
          if tags[tag.id]
            tags[tag.id] += dictionary[term.name]
          else
            tags[tag.id] = dictionary[term.name]
          end
        end
      end

      tags
    end

    # Finds Common terms with the article body dictionary. Takes an array of strings
    def get_article_terms(terms)
      Term.where(name: terms)
    end

    def get_article_url(article)
      if valid_url?(article.url)
        article.url
      elsif valid_url?(article.source.url + article.url)
        article.source.url + article.url
      end
    end

    def get_article_body(article)
      p '/////////////////////////////////////////////////////////'
      p 'GET ARTICLE BODY'
      # get_article_url(article)
      return if article.browsed

      article_url = get_article_url(article) # Verifies the url is valid
      return unless article_url

      p 'Article body after return!'
      # Scrape HTML
      html = URI.open(article_url).read
      html = Nokogiri::HTML.parse(html)
      retrieved_title = html.title
      retrieved_paragraphs = html.css('article p')
      retrieved_paragraphs = retrieved_paragraphs.map { |paragraph| paragraph.text }

      # Report Scrape
      total_words_count = 0
      retrieved_paragraphs.each { |piece| total_words_count += piece.split.size }
      puts 'Total Words Count'
      # p total_words_count
      # p article.source.name

      body_string = ''
      retrieved_paragraphs.each { |paragraph| body_string += (paragraph + "\n") }

      body_string
    end
  end
end
