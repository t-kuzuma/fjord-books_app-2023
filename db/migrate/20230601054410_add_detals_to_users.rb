class AddDetalsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :postcode, :string
    add_column :users, :address, :text
    add_column :users, :introduction, :text
  end
end
