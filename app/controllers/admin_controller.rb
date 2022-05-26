class AdminController < ApplicationController
  def index
  end

  def find_tags
    p 'Find tags'
    redirect_to root_path
  end
  private

end
