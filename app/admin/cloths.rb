ActiveAdmin.register Cloth do
  permit_params :name, :hire, :lost, :link, :quantity, :funds, :description, :parent_id, images_attributes: [:name]

  index do
    selectable_column
    id_column
    column :name
    column :hire
    column :lost
    column :lost
    column :link
    column :quantity
    column :funds
    column :description
    column :parent_id

    actions
  end

  form(:html => { :multipart => true }) do |f|
    f.inputs 'Plus' do
      f.input :name
      f.input :hire
      f.input :lost
      f.input :lost
      f.input :link
      f.input :quantity
      f.input :funds
      f.input :description, :input_html => { :rows => 5, :maxlength => 1000  }
      f.input :parent_id
      f.has_many :images do |image|
        image.inputs 'Image', :multipart => true do 
          image.input :name, as: :file
        end
      end
    end
    f.actions
  end
end
