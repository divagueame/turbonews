class RemoveUrlFromArticles < ActiveRecord::Migration[7.0]
  def change
    remove_column :articles, :url
    add_column :articles, :url, :string
    add_index :articles, :url, unique: true
  end
end
