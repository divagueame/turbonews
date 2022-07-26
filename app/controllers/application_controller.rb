class ApplicationController < ActionController::Base
  include Extracter
  include Pagy::Backend
end
