ActiveAdmin.register Notification do
  permit_params :title, :description, :article_id, :image
  
    index do
      selectable_column
      id_column
      column :title
      column :description
      column :image
      column :article_id

      actions
    end
  
    form(:html => { :multipart => true }) do |f|
      f.input :title
      f.input :description
      f.input :article_id
      f.inputs "Attachment", :multipart => true do 
        f.input :image, as: :file
      end
  
      f.actions
    end
  end
  