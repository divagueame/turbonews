require 'nokogiri'
require 'open-uri'
class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy scrape_article]

  # GET /articles or /articles.json
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

  # GET /articles/1 or /articles/1.json
  def show; end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit; end

  # POST /articles or /articles.json
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

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: 'Article was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def scrape_article
    get_article_url(@article)
    if @article.browsed
      p 'Already browsed. Skip'
    else
      p 'Never browser'
      article_url = get_article_url(@article)

      html = URI.open(article_url).read
      html = Nokogiri::HTML.parse(html)
      retrieved_title = html.title
      retrieved_paragraphs = html.css('article p')
      retrieved_paragraphs = retrieved_paragraphs.map { |paragraph| paragraph.text }

      total_words_count = 0
      retrieved_paragraphs.each { |piece| total_words_count += piece.split.size }

      puts 'Total Words Count'
      p total_words_count
      p article_url
      puts "\n"
      puts retrieved_paragraphs

    end
  end

  private

  def scrape_body(html); end

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:header, :body, :url, :source_id)
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
end
