class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :header
      t.text :body
      t.string :url

      t.timestamps
    end
  end
end
