class CreateAgendas < ActiveRecord::Migration[5.1]
  def change
    create_table :agendas do |t|
      t.integer :minute_ticket, null: false
      t.text :name, null: false
      t.references :schedule, null: false
      t.integer :tenant_id, index: true
      t.timestamps
    end
  end
end
