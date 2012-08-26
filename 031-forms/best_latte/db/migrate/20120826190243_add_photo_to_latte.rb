class AddPhotoToLatte < ActiveRecord::Migration
  def change
    rename_column :lattes, :photo_url, :photo
  end
end
