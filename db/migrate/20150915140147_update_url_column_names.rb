class UpdateUrlColumnNames < ActiveRecord::Migration
  def change
    rename_column :videos, :small_cover_URL, :small_cover_url
    rename_column :videos, :large_cover_URL, :large_cover_url
  end
end
