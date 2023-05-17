class CreateLots < ActiveRecord::Migration[7.0]
  def change
    create_table :lots do |t|
      t.string :code
      t.date :initial_date
      t.date :limit_date
      t.decimal :minimum_bid
      t.decimal :minimum_bid_increment
      t.integer :status, default: 0
      t.references :creator, null: false, foreign_key: { to_table: :admins}
      t.references :publisher, foreign_key: { to_table: :admins }

      t.timestamps
    end
  end
end
