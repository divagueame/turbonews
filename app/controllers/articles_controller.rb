class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show edit update destroy ]

  # GET /articles or /articles.json
  def index
    if params[:query].present?
      # @articles = Article.where("header LIKE ?", "#{params[:query]}%")
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

  # GET /articles/1 or /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles or /articles.json
  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." } 
      else
        format.html { render :new, status: :unprocessable_entity } 
      end
    end
  end

  # PATCH/PUT /articles/1 or /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." } 
      else
        format.html { render :edit, status: :unprocessable_entity } 
      end
    end
  end

  # DELETE /articles/1 or /articles/1.json
  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def scrape_article
    p params
    p 'YEAS'
    puts "\n"
    puts "\n"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:header, :body, :url)
    end
end
