class Term < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :tag_terms, dependent: :destroy
  has_many :tags, through: :tag_terms
end
