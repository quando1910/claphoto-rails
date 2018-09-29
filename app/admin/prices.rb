ActiveAdmin.register Price do
  permit_params :num_pp, :price, ,:offer ,:types ,:priceFirst ,:aspect ,:takenTime

  index do
    selectable_column
    id_column
    column :num_pp
    column :price
    column :offer
    column :types
    column :priceFirst
    column :aspect
    column :takenTime

    actions
  end

  form do |f|
    f.inputs do
      f.input :num_pp, label: "Number of people"
      f.input :price
      f.input :offer
      f.input :types
      f.input :priceFirst
      f.input :aspect
      f.input :takenTime
    end
    f.actions
  end

end
