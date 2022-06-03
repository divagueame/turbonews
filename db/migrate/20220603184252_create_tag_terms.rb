class CreateTagTerms < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_terms do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :term, null: false, foreign_key: true

      t.timestamps
    end
  end
end
