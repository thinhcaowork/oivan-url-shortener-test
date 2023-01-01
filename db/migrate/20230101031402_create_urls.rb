class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls do |t|
      t.text :original, index: { unique: true }
      t.string :short, index: { unique: true }

      t.timestamps
    end
  end
end
