class Source < ApplicationRecord
  has_many :articles, dependent: :destroy
end
