class ArticleTagController < ApplicationController


  def create
    p "Create article tag Controller"
    @article_tag = ArticleTag.new(article_tag)

    respond_to do |format|
      if @article_tag.save
        format.html { redirect_to articles_path, notice: "Tag was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end


  private


  def article_tag_params
    params.require(:article).permit(:article_id, :tag_id)
  end



end
