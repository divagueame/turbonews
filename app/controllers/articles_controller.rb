require 'nokogiri'
require 'open-uri'
# require 'uri'
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
        tags.each do |tag_id, count|
          ArticleTag.create(article_id: art.id, tag_id:) if count > 1
        end

        if @article_tag.valid?
          @article_tag.save
          # return redirect_to article_path(article), notice: 'Tags updated'
        else
          # return redirect_to article_path(article), notice: 'Error! Tags could not be updated'
        end
      end
    end
    @articles = if params[:query].present?
                  Article.search_all("#{params[:query]}")

                else
                  Article.all.limit(10)
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

  def update_all
    if params[:browse_today_bodies].present?
      Article.where(created_at: Time.now.all_day).order('RANDOM()').each do |art|
        next if art.browsed
        next if art.body.present?

        body = get_article_body(art)

        next if body.nil?

        art.update(body:, browsed: true) if body.length > 40
        art.update(body:, browsed: true, is_valid: false) if body.length <= 40
        sleep 10
      end
    end
  end

  def update
    if params['full_scrape']
      @article.body = get_article_body(@article)
      @article.browsed = true
      if @article.valid?
        @article.save
        return redirect_to article_path(@article), notice: 'Body scanned properly'
      else
        return redirect_to article_path(@article), notice: 'Error! Body could not be scanned'
      end
    end

    if params['get_tags']
      @article_tag = ArticleTag.find_or_initialize_by(article_id: @article.id)
      tags = get_article_tags(@article)
      tags.each do |tag_id, count|
        ArticleTag.create(article_id: @article.id, tag_id:) if count > 1
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
    params.require(:article).permit(:header, :body, :url, :source_id, :browsed, :find_all_tags, :browse_today_bodies,
                                    :is_valid)
  end
end
