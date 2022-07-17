class TermsController < ApplicationController
#   before_action :set_tag, only: %i[show edit update destroy]

#   def index
#     @tags = Tag.all
#   end

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

  def update
    
#     respond_to do |format|
#       if @tag.update(tag_params)
#         format.html { redirect_to tag_url(@tag), notice: 'Tag was successfully updated.' }
#       else
#         format.html { render :edit, status: :unprocessable_entity }
#       end
#     end
  end

#   # DELETE /tags/1 or /tags/1.json
#   def destroy
#     @tag.destroy

#     respond_to do |format|
#       format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
#       format.json { head :no_content }
#     end
#   end

  private

#   def set_tag
#     @tag = Tag.find(params[:id])
#   end

#   def tag_params
#     params.require(:tag).permit(:name, :active)
#   end

#   def tags_params
#     params.permit(
#       tags: %i[name active]
#     ).require(:tags)
#     # params.require(:tags).permit({ tags: {:name} })
#   end
end
