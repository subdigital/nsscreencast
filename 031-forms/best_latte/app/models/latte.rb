class Latte < ActiveRecord::Base
  attr_accessible :comments, :location, :photo_url, :submitted_by
end
