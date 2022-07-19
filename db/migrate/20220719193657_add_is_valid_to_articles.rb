class AddIsValidToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :is_valid, :boolean, default: true
  end
end
