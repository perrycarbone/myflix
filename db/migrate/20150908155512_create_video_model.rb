class CreateVideoModel < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.text :description
      t.string :small_cover_URL
      t.string :large_cover_URL

      t.timestamps
    end
  end
end
