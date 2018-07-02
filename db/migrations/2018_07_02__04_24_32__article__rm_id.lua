local SqlMigration = {}

-- for safety
SqlMigration.run_in_transaction = true

-- db argument is SqlMigration.db instance provided by migrations engine

function SqlMigration.up(db)
  db:execute [[
    ALTER TABLE public.article
      DROP CONSTRAINT article_pkey;
  ]]

  db:execute [[
    ALTER TABLE public.article DROP COLUMN id;
  ]]

  db:execute [[
    ALTER TABLE public.article
      ADD CONSTRAINT article_pkey PRIMARY KEY (system_name);
  ]]

  print 'Note: article.id is deprecated. article.system_name would be primary key'
end

function SqlMigration.down(db)
  db:execute [[
    ALTER TABLE public.article
      DROP CONSTRAINT article_pkey;
  ]]

  db:execute [[
    ALTER TABLE public.article ADD COLUMN id SERIAL;
  ]]

  db:execute [[
    ALTER TABLE public.article
      ADD CONSTRAINT article_pkey PRIMARY KEY (id);
  ]]
end

return SqlMigration
