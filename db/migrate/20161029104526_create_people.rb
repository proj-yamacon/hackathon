class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :image_name
      t.integer :gender
      t.int :temperature_preference
      t.float :comfortable_temperature
      t.float :comfortable_humidity

      t.timestamps null: false
    end
    add_index :people, :name
  end
end
