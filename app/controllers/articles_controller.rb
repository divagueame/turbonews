require 'nokogiri'
require 'open-uri'
require 'set'
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    if params[:find_all_tags].present?
      @articles = Article.all
      @articles.each do |art|
        next unless art.browsed
        next unless art.body.present?
        # p article.body
        @article_tag = ArticleTag.find_or_initialize_by(article_id: art.id)
        tags = get_article_tags(art)
        tags.each do |tag_id,count|
          if(count>1)
            ArticleTag.create(article_id: art.id, tag_id: tag_id)
          end
        end
        
        if @article_tag.valid?
          @article_tag.save
          # return redirect_to article_path(article), notice: 'Tags updated'
        else
          # return redirect_to article_path(article), notice: 'Error! Tags could not be updated'
        end


      end
    end
    if params[:query].present?
      @articles = Article.search_all("#{params[:query]}");
      
    else
      @articles = Article.all
    end

    if turbo_frame_request?
      render partial: 'articles', locals: { articles: @articles }
    else
      render :index
    end
  end

  def show; end

  def new
    @article = Article.new
  end

  def edit; end

  def create
    @article = Source.first.articles.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: 'Article was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params['full_scrape']
      @article.body = get_article_body(@article)
      @article.browsed = true
      if @article.valid?
        @article.save
        return redirect_to articles_path, notice: 'Body scanned properly'
      else
        return redirect_to articles_path, notice: 'Error! Body could not be scanned'
      end
    end

    if params['get_tags']
      @article_tag = ArticleTag.find_or_initialize_by(article_id: @article.id)
      tags = get_article_tags(@article)
      tags.each do |tag_id,count|
        if(count>1)
          ArticleTag.create(article_id: @article.id, tag_id: tag_id)
        end
      end
      
      if @article_tag.valid?
        @article_tag.save
        return redirect_to article_path(@article), notice: 'Tags updated'
      else
        return redirect_to article_path(@article), notice: 'Error! Tags could not be updated'
      end

    end

    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: 'Article was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:header, :body, :url, :source_id, :browsed, :find_all_tags)
  end

  def valid_url?(url)
    (url[0, 3] === 'htt') || (url[0, 3] === 'www') ? true : false
  end

  def get_article_url(article)
    if valid_url?(article.url)
      article.url
    elsif valid_url?(article.source.url + article.url)
      article.source.url + article.url
    else
      p 'ERROR. Not available url'
      p article.source.url
      p article.url
      nil
    end
  end

  def get_article_body(article)
    get_article_url(article)
    return if article.browsed

    article_url = get_article_url(article) # Verifies the url is valid
    return unless article_url

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
    p total_words_count

    body_string = ''
    retrieved_paragraphs.each { |paragraph| body_string += (paragraph + "\n") }

    body_string
  end

  # Creates dictionary of the article body
  def get_article_body_dictionary(article)
    words_count = {}
    words_array = article.body.downcase.split(/[,\s]+/).select { |word| word.length >= 3 }
    words_array.each { |word| words_count[word] ? words_count[word] += 1 : words_count[word] = 1 }
    words_count
  end

  # Finds Common terms with the article body dictionary. Takes an array of strings
  def get_article_terms(terms)
    Term.where(name: terms)
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
end
