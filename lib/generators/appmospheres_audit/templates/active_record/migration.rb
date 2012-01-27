class AppmospheresAuditMigration < ActiveRecord::Migration

  def self.up

    create_table :event_logs do |t|
      t.string :event_type
      t.string :action
      t.text :payload

      t.datetime :reported_at
      t.timestamps
    end

    add_index :event_logs, :event_type
    add_index :event_logs, :action
    add_index :event_logs, :reported_at

  end

  def self.down
    drop_table :event_logs
  end

end
