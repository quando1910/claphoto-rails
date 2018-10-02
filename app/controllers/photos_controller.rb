class PhotosController < ApplicationController
  def create
    if params[:photo][:photo]
      params[:photo][:photo].each do |a|
        @photo = Photo.create!(:photo => a, :kind => params[:photo][:kind])
      end
    end
    redirect_to admin_photos_path
  end
end
