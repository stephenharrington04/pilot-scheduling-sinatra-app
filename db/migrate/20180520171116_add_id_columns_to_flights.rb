class AddIdColumnsToFlights < ActiveRecord::Migration[5.2]
  def change
    add_column :flights, :instructor_id, :integer
    add_column :flights, :student_id, :integer
  end
end
