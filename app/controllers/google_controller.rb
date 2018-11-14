class GoogleController < ApplicationController
  require 'google/apis/drive_v3'
  require 'google/api_client/client_secrets'
  require "net/http"
  require "uri"

  before_action :authorize_drive, only: [:oauth]

  def create 
    @viewers = Contract.find(params[:id]).viewers.where(typeFile: 1)
    img_arr = []
    #each items
    @viewers.each do |v|
      drive = v.drive_link.split(',')
      drive.each do |d|
        result = Net::HTTP.get(URI.parse("https://www.googleapis.com/drive/v3/files?orderBy=name&q=%"+ d +"%27%20in%20parents&pageSize=500&key=AIzaSyAWORBYVthrcHPXGp5nYTs3QI9f5jH6_Jg"))
        resultJSON = JSON.parse(result, object_class: OpenStruct).files.sort {|a,b| b.name <=> a.name }
        image_ids = []
        image_names = []
        resultJSON.each do |image|
          image_ids.push(image.id)
          image_names.push(image.name)
        end
        str_img_ids = image_ids.join(',')
        str_img_names = image_names.join(',')
        img_arr.push({pictureId: str_img_ids, name: str_img_names, mimeType: 'image/jpeg', folder: d, viewer_id: v.id})
      end
    end
    if Picture.create(img_arr)
      render status: 200
    else 
      render status: 400
    end
  end

  def authorize_drive
    uri   = URI.parse(request.fullpath)
    @id = ''
    if uri.query
      params = CGI.parse(uri.query)
      @id  = params['id'].first
    end
    if @id 
      session[:id] = @id
    end
    client_secrets = Google::APIClient::ClientSecrets.load("#{Rails.root}/config/client_secrets.json")
    auth_client = client_secrets.to_authorization
    if request['code'] == nil
      auth_client.update!(
        :additional_parameters => {
          "access_type" => "offline",
          "include_granted_scopes" => "true"
        },
        :state =>  @id,
        :scope => 'https://www.googleapis.com/auth/drive.metadata.readonly',
        :redirect_uri => "http://localhost:3000/oauth2callback" )
        # :redirect_uri => "http://manage.theclassic.studio/oauth2callback" )
      auth_uri = auth_client.authorization_uri.to_s
      redirect_to(auth_uri)
    else
      auth_client.code = request['code']
      auth_client.fetch_access_token!
      auth_client.client_secret = nil
      session[:credentials] = auth_client.to_json
    end
  end

  def oauth
    unless session.has_key?(:credentials)
      redirect_to('/oauth2callback')
    end
    client_opts = JSON.parse(session[:credentials])
    #excute here
    auth_client = Signet::OAuth2::Client.new(client_opts)
    drive = Google::Apis::DriveV3::DriveService.new
    # encode
    img_arr = []
    @viewers = Contract.find(session[:id]).viewers.where(typeFile: 1)
    #each items
    @viewers.each do |v|
      drive_id = v.drive_link.split(',')
      drive_id.each do |d|
        files = drive.list_files( page_size: 500,
                                  q: "'#{d}' in parents",
                                  fields: 'files(id, original_filename)',
                                  options: { authorization: auth_client })
        image_ids = []
        image_names = []
        files.files.sort {|x,y| y.original_filename <=> x.original_filename }.each do |image|
          image_ids.push(image.id)
          image_names.push(image.original_filename)
        end
        str_img_ids = image_ids.join(',')
        str_img_names = image_names.join(',')
        img_arr.push({pictureId: str_img_ids, name: str_img_names, mimeType: 'image/jpeg', folder: d, viewer_id: v.id})
      end
    end
    if Picture.create(img_arr)
      redirect_to admin_contract_path(session[:id])
    else 
      render status: 400
    end
  end

end
