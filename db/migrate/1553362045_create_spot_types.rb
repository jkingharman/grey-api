# frozen_string_literal: true

class CreateSpotTypes < ActiveRecord::Migration[5.2]
  create_table :spot_types do |t|
    t.references :spot

    t.string :name, null: false, unique: true
    t.string :slug, null: false, unique: true
    t.timestamps
  end
end
