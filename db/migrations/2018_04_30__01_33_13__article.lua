local SqlMigration = {}

SqlMigration.run_in_transaction = true

-- db argument is SqlMigration.db instance provided by migrations engine

function SqlMigration.up(db)
  db:execute([[
CREATE TYPE enum_article_content_type AS ENUM ('markdown', 'html');
  ]])

  db:execute([[
    CREATE TABLE article (
        id SERIAL,
        name TEXT,
        system_name TEXT NOT NULL,
        content_type enum_article_content_type DEFAULT 'html',
        content TEXT,
        active BOOLEAN NOT NULL DEFAULT true
    );
  ]])
end

function SqlMigration.down(db)
  db:execute('DROP TABLE article;')
  db:execute('DROP TYPE enum_article_content_type;')
end

return SqlMigration
