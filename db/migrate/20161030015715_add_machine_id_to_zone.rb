class AddMachineIdToZone < ActiveRecord::Migration
  def change
    add_column :zones, :machine_id, :integer
  end
end
