class Tag < ApplicationRecord
  validates :name, uniqueness: true
  has_many :article_tags
  has_many :articles, through: :article_tags
end
