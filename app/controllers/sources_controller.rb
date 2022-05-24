
require 'nokogiri'
require 'open-uri'

class SourcesController < ApplicationController
  before_action :set_source, only: %i[ show edit update destroy ]

  # GET /sources or /sources.json
  def index
    @sources = Source.all
  end

  def scrap
    Source.all.each do |source|
      id = source.id
      url = source.url
      selector = source.selector
      relative_url = source.relative_url

      html = URI.open(source.url.to_s).read
      header = Nokogiri::HTML(html)
      header.css(selector).each do |piece|
        @article = Article.new
        @article.header = piece.text
        @article.url = piece.attribute('href').value
        @article.source_id = source.id

          if(@article.valid?)
            @article.save
          else
            p 'Article not saved'
          end
        end
    end
  end
   

 
  # GET /sources/1 or /sources/1.json
  def show
  end

  # GET /sources/new
  def new
    @source = Source.new
  end

  # GET /sources/1/edit
  def edit
  end

  # POST /sources or /sources.json
  def create
    @source = Source.new(source_params)

    respond_to do |format|
      if @source.save
        format.html { redirect_to source_url(@source), notice: "Source was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sources/1 or /sources/1.json
  def update
    respond_to do |format|
      if @source.update(source_params)
        format.html { redirect_to source_url(@source), notice: "Source was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1 or /sources/1.json
  def destroy
    @source.destroy

    respond_to do |format|
      format.html { redirect_to sources_url, notice: "Source was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_source
      @source = Source.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def source_params
      params.require(:source).permit(:name, :url, :selector, :relative_url)
    end
end
