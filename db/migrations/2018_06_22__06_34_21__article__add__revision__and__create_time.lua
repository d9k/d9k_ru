local SqlMigration = {}

-- for safety
SqlMigration.run_in_transaction = true

-- db argument is SqlMigration.db instance provided by migrations engine

function SqlMigration.up(db)
  db:execute [[
    ALTER TABLE public.article
      ADD COLUMN revision uuid NOT NULL DEFAULT uuid_generate_v4(),
      ADD COLUMN create_time timestamp without time zone default (now() at time zone 'utc'),
      ADD COLUMN modify_time timestamp without time zone default (now() at time zone 'utc');
  ]]
end

function SqlMigration.down(db)

end

return SqlMigration
