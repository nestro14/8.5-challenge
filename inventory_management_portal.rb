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

def insert_card_into_inventory(card)
card_format = "'#{card[0].gsub(/'/, '')}', #{card[1].to_i}, '#{card[2]}', '#{card[3]}', #{card[4].to_i}, #{card[5].to_f}, #{card[6].to_i}"

  DB.execute("
    UPDATE cards SET qty = qty + #{card[6].to_i}
    WHERE name = '#{card[0].gsub(/'/, '')}'
    AND edition = #{card[1].to_i}
    AND color = '#{card[2]}'
    AND type = '#{card[3]}'
    AND foil = #{card[4].to_i};")

  DB.execute("INSERT OR IGNORE INTO cards (id, name, edition, color, type, foil, price, qty) VALUES ((SELECT id FROM cards WHERE name = '#{card[0].gsub(/'/, '')}'
            AND edition = #{card[1].to_i}
            AND color = '#{card[2]}'
            AND type = '#{card[3]}'
            AND foil = #{card[4].to_i}),#{card_format});")
end

def update_card_price(card)
  DB.execute("
    UPDATE cards SET price = #{card[5].to_f}
    WHERE name = '#{card[0].gsub(/'/, '')}'
    AND edition = #{card[1].to_i}
    AND color = '#{card[2]}'
    AND type = '#{card[3]}'
    AND foil = #{card[4].to_i};")
end

def remove_card_from_inventory(card)
  DB.execute("
    DELETE FROM cards
    WHERE name = '#{card[0].gsub(/'/, '')}'
    AND edition = #{card[1].to_i}
    AND color = '#{card[2]}'
    AND type = '#{card[3]}'
    AND foil = #{card[4].to_i}
    AND qty == #{card[6].to_i};")

    DB.execute("
    UPDATE cards SET qty = qty - #{card[6].to_i}
    WHERE name = '#{card[0].gsub(/'/, '')}'
    AND edition = #{card[1].to_i}
    AND color = '#{card[2]}'
    AND type = '#{card[3]}'
    AND foil = #{card[4].to_i}
    AND qty - #{card[6].to_i} >= 1;")
end

def import_csv(file_name)
  begin
    card_info = File.read(file_name).split(/\r\n/)

    card_info.each do |card|
      card = card.split(",")
      insert_card_into_inventory(card)
    end

    puts "The file #{file_name} was loaded succesfully."
  rescue Exception => e
    puts e.message
    puts "There was a problem loading the file."
  end
end

def display_menu
  puts "\t1 - Import a CSV file into inventory."
  puts "\t2 - Add card(s) to the inventory."
  puts "\t3 - Update the price of a card."
  puts "\t4 - Remove card(s) from innventory."
  puts "\tq - Exit."
end

def valid_digit?(digit)
  digit == digit.to_i.to_s || digit.to_f.to_s == digit || digit.to_f.real?
end

def enter_valid_digit(valid_digit=0)
  until valid_digit?(valid_digit)
    valid_digit = gets.chomp
    puts "Enter a valid digit" if valid_digit?(valid_digit) == false
  end
  valid_digit
end