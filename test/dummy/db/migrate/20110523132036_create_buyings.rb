class CreateBuyings < ActiveRecord::Migration
  def self.up
    create_table :buyings do |t|
      t.integer :user_id
      t.integer :book_id
      t.integer :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :buyings
  end
end
