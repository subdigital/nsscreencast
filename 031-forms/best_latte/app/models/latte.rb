class Latte < ActiveRecord::Base
  attr_accessible :comments, :location, :photo, :submitted_by
  mount_uploader :photo, PhotoUploader
end
