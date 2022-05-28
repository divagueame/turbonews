require 'nokogiri'
require 'open-uri'

class SourcesController < ApplicationController
  before_action :set_source, only: %i[show edit update destroy]

  # GET /sources or /sources.json
  def index
    @sources = Source.all
  end

  def scrape_all
    reports = []
    Source.all.each do |source|
      scrape_report = scrape_source(source)
      reports.push(scrape_report)
    end
    
    # Reports of the scraping
    reports.each do |report| 
      puts "\n"
      pp "Source: #{report[:source_name]}"
      pp "Saved: #{report[:saved]}"
      pp "Not saved: #{report[:not_saved]}"
    end
  
    puts "\n"
    redirect_to :articles
  end

  def show; end

  # GET /sources/new
  def new
    @source = Source.new
  end

  # GET /sources/1/edit
  def edit; end

  # POST /sources or /sources.json
  def create
    @source = Source.new(source_params)

    respond_to do |format|
      if @source.save
        format.html { redirect_to source_url(@source), notice: 'Source was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sources/1 or /sources/1.json
  def update
    respond_to do |format|
      if @source.update(source_params)
        format.html { redirect_to source_url(@source), notice: 'Source was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1 or /sources/1.json
  def destroy
    @source.destroy

    respond_to do |format|
      format.html { redirect_to sources_url, notice: 'Source was successfully destroyed.' }
    end
  end

  private

  def scrape_source(source)
    report = {:source_name=> source.name, :not_saved => 0, :saved => 0}
 
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

      if @article.valid?
        @article.save
        report[:saved] += 1  
      else
        report[:not_saved] += 1  
      end
    end
    
    report
  end

  def set_source
    @source = Source.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def source_params
    params.require(:source).permit(:name, :url, :selector, :relative_url)
  end
end
