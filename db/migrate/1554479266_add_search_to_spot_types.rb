# frozen_string_literal: true

class AddSearchToSpotTypes < ActiveRecord::Migration[5.2]
  def up
    # Add col to cache lexemes and search against.
    add_column :spot_types, :tsv, 'TSVector'

    # Add GIN index to col for search speed.
    execute <<-SQL
      CREATE INDEX spot_types_tsv_gin ON spots \
      USING GIN(tsv);
    SQL

    # First, create tsv trigger. Then use pg built-in trigger to
    # update tsvector on changes.
    execute <<-SQL
      CREATE TRIGGER spot_types_ts_tsv \
      BEFORE INSERT OR UPDATE ON spot_types \
      FOR EACH ROW EXECUTE PROCEDURE \
      tsvector_update_trigger(tsv, 'pg_catalog.english', name);
    SQL

    execute <<-SQL
      UPDATE spot_types SET tsv=to_tsvector(name);
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER spot_types_ts_tsv ON spot_types \
      DROP INDEX spot_types_tsv_gin;}
    SQL

    drop_column :spot_types, :tsv
  end
end
