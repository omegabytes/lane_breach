class Add311CasesData < ActiveRecord::Migration[5.2]
  def change
    create_table :sf_311_cases do |t|
      t.string :status_description
      t.string :police_district
      t.timestamps      
    end
  end
end
