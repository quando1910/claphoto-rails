class Photo < ApplicationRecord
  mount_uploader :photo, PhotohdsUploader
  belongs_to :story, optional: true
end
