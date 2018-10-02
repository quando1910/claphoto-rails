class Photo < ApplicationRecord
  mount_uploader :photo, PhotohdUploader
  belongs_to :story, optional: true
end
