class AddSelectorToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :selector, :string
  end
end
