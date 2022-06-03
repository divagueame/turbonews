class TagTerm < ApplicationRecord
  belongs_to :tag
  belongs_to :term
end
