local SqlMigration = {}

-- for safety
SqlMigration.run_in_transaction = true

-- db argument is SqlMigration.db instance provided by migrations engine

function SqlMigration.up(db)
  db:execute([[
    ALTER TABLE article
      ADD COLUMN global_id UUID NOT NULL DEFAULT uuid_generate_v4();
  ]])
end

function SqlMigration.down(db)
  db:execute([[
    ALTER TABLE article DROP COLUMN global_id;
  ]])
end

return SqlMigration
