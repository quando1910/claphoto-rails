class AddColumntoCloths < ActiveRecord::Migration[5.1]
  def change
    add_column :cloths, :description, :string
  end
end
