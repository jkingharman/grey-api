# frozen_string_literal: true

class CreateSpotTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :spot_types do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
  end
end
