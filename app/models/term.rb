class Term < ApplicationRecord
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  before_validation :downcase_name
  has_many :tag_terms, dependent: :destroy
  has_many :tags, through: :tag_terms

  private

  def downcase_name
    self.name = name.downcase
  end
end
