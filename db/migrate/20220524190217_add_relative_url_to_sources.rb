class AddRelativeUrlToSources < ActiveRecord::Migration[7.0]
  def change
    add_column :sources, :relative_url, :boolean, default: false
  end
end
