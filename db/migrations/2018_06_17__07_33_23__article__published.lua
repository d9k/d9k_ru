local SqlMigration = {}

-- for safety
SqlMigration.run_in_transaction = true

-- db argument is SqlMigration.db instance provided by migrations engine

function SqlMigration.up(db)
  db:execute [[
    ALTER TABLE public.article
      ADD COLUMN published boolean DEFAULT false;
  ]]
end

function SqlMigration.down(db)
  db:execute [[
    ALTER TABLE public.article DROP COLUMN published;
  ]]
end

return SqlMigration
