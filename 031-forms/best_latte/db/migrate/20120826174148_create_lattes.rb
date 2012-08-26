class CreateLattes < ActiveRecord::Migration
  def change
    create_table :lattes do |t|
      t.string :location
      t.text :comments
      t.string :photo_url
      t.string :submitted_by

      t.timestamps
    end
  end
end
