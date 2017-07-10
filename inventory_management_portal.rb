require 'sqlite3'

DB = SQLite3::Database.new('card_inventory.db')

card_schema = <<-SQL
  CREATE TABLE IF NOT EXISTS cards(
    id INTEGER PRIMARY KEY,
    name TEXT,
    edition INTEGER,
    color VARCHAR(255),
    type VARCHAR(255),
    foil BOOLEAN,
    price REAL,
    qty INTEGER
  );
SQL

def create_database(schema)
  DB.execute(schema)
end