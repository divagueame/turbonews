require 'nokogiri'
require 'open-uri'
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @articles = if params[:query].present?
                  # @articles = Article.where("header LIKE ?", "#{params[:query]}%")
                  Article.search_all(params[:query].to_s)
                else
                  Article.all
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
      @article_tag.tag_id = 1
      p 'Got so far'
      p @article_tag 
      p @article_tag.valid?
      p @article_tag.errors
      p 'Got so far'
      # @article_tag.update_attributes!(params_for_create_or_update)
      # flash[:notice] = 'Article Tags updated'
      # redirect_to action: :show

      if @article_tag.valid?
        @article_tag.save
        return redirect_to article_path(@article), notice: 'Tag updated'
      else
        # return redirect_to articles_path, notice: 'Error! Body could not be scanned'
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
      format.json { head :no_content }
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    # p 'AND :'
    # p params
    params.require(:article).permit(:header, :body, :url, :source_id, :browsed)
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
end
