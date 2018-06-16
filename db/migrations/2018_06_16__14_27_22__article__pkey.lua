local SqlMigration = {}

-- for safety
SqlMigration.run_in_transaction = true

-- db argument is SqlMigration.db instance provided by migrations engine

function SqlMigration.up(db)
  db:execute [[
    ALTER TABLE public.article
      ADD CONSTRAINT article_pkey PRIMARY KEY (id);
  ]]
end

function SqlMigration.down(db)
  db:execute [[
    ALTER TABLE public.article
      DROP CONSTRAINT article_pkey;
  ]]
end

return SqlMigration
