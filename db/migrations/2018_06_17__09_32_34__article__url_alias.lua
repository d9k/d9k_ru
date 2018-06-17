local SqlMigration = {}

-- for safety
SqlMigration.run_in_transaction = true

-- db argument is SqlMigration.db instance provided by migrations engine

function SqlMigration.up(db)
  db:execute [[
    ALTER TABLE public.article
        ADD COLUMN url_alias text COLLATE pg_catalog."default";
  ]]
end

function SqlMigration.down(db)
  db:execute [[
    ALTER TABLE public.article
        DROP COLUMN url_alias;
  ]]
end

return SqlMigration
