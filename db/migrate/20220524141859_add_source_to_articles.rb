class AddSourceToArticles < ActiveRecord::Migration[7.0]
  def change
    add_reference :articles, :source, null: false, foreign_key: true
  end
end
