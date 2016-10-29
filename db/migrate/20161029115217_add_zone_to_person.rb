class AddZoneToPerson < ActiveRecord::Migration
  def change
    add_column :people, :zone_id, :integer
  end
end
