class TermsController < ApplicationController
  #   before_action :set_tag, only: %i[show edit update destroy]

  def index
    @terms = Term.all
  end

  #   def show
  #     @articles = @tag.articles
  #   end

  #   def new
  #     @tag = Tag.new
  #   end

  #   def edit; end

  #   def create
  #     @tag = Tag.new(tag_params)
  #     respond_to do |format|
  #       if @tag.save
  #         format.html { redirect_to tags_url, notice: 'Tag was successfully created.' }
  #       else
  #         format.html { render :new, status: :unprocessable_entity }
  #       end
  #     end
  #   end

  def update_all
    if params[:update_all_terms].present?
      pre_counter = Term.all.count
      tags = {}
      @articles = Article.where(browsed: true)
      @articles.each do |art|
        article_terms = get_article_body_dictionary(art, 3)
        terms = Hash[article_terms.sort_by { |_k, v| -v }[0..3]]
        terms.each_key do |key|
          @term = Term.find_or_initialize_by(name: key)
          @term.save if @term.valid?
        end
      end
      after_counter = Term.all.count - pre_counter

      msg = "#{after_counter} new terms added."
      redirect_to admin_path, notice: msg

    end
  end

  def update
    tags = {}
    @article = Article.find(params['article_id'])

    article_terms = get_article_body_dictionary(@article, 3)

    terms = Hash[article_terms.sort_by { |_k, v| -v }[0..3]]
    terms.each_key do |key|
      @term = Term.find_or_initialize_by(name: key)
      @term.save if @term.valid?
    end

    # respond_to do |format|
    #   format.html { redirect_to article_url(@article), notice: 'New terms updated from this article' }
    # end
  end

  #   # DELETE /tags/1 or /tags/1.json
  #   def destroy
  #     @tag.destroy

  #     respond_to do |format|
  #       format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
  #       format.json { head :no_content }
  #     end
  #   end

  #   def set_tag
  #     @tag = Tag.find(params[:id])
  #   end

  def term_params
    params.require(:term).permit(:article_id, :update_all_terms)
  end

  #   def tags_params
  #     params.permit(
  #       tags: %i[name active]
  #     ).require(:tags)
  #     # params.require(:tags).permit({ tags: {:name} })
  #   end
end
