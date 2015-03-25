class CreateBatches < ActiveRecord::Migration
  def change
    create_table :batches do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :filename
      t.string :batch_status

      t.timestamps
    end
  end
end
