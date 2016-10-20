class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :date
      t.string :city
      t.string :state
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :events, :users
  end
end
