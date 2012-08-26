ActiveAdmin.register Latte do
  index do
    column :id
    column :location
    column :photo do |latte|
      image_tag latte.photo.thumb_retina.url
    end
    column :comments
    column :submitted_by
  end

  show do |latte|
    attributes_table do
      row :id
      row :location
      row :photo do
        image_tag latte.photo.url
      end
      row :comments
      row :submitted_by
    end
  end
end
