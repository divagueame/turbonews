class AddBrowsedToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :browsed, :boolean, default: false
  end
end
