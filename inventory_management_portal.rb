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

## DRIVER CODE ##
create_database(card_schema)

puts "=> Welcome to the Inventory Management Portal"
puts "=> Please choose from the options below.\n"
option = nil

loop do
  display_menu

  option = gets.chomp
  break if option.downcase.start_with?('q')

  case option
  when '1'
    puts "Please enter the name of the csv file along with its extension:"
    fname = gets.chomp
    until `find #{fname}`.chomp == fname
      puts "Try again or type m to return to the main menu."
      fname = gets.chomp
      break if fname.downcase.start_with?('m')
    end
    import_csv(fname)
  when '2'
    card = []
    puts "Card Name:"
    card << gets.chomp
    puts "Card Edition:"
    card << enter_valid_digit(gets.chomp).to_i
    puts "Card Color:"
    card << gets.chomp
    puts "Card Type:"
    card << gets.chomp
    puts "Is the card a Foil? Enter 1 for yes and 0 for no:"
    card << enter_valid_digit(gets.chomp).to_i
    puts "Card Price:"
    card << enter_valid_digit(gets.chomp).to_f
    puts "How many of this card would you like to add to inventory?"
    card << enter_valid_digit(gets.chomp).to_i
    insert_card_into_inventory(card)
  when '3'
    puts "What is the name of the card you wish to update?"
    card = []
    puts "Card Name:"
    card << gets.chomp
    puts "Card Edition:"
    card << enter_valid_digit(gets.chomp).to_i
    puts "Card Color:"
    card << gets.chomp
    puts "Card Type:"
    card << gets.chomp
    puts "Is the card a Foil? Enter 1 for yes and 0 for no:"
    card << enter_valid_digit(gets.chomp).to_i
    puts "Card Price:"
    card << enter_valid_digit(gets.chomp).to_f
    update_card_price(card)
    # puts "If the card's price did not update you entered in the wrong info or the card is not in inventory."
  when '4'
    puts "What is the name of the card you wish to remove/update?"
    card = []
    puts "Card Name:"
    card << gets.chomp
    puts "Card Edition:"
    card << enter_valid_digit(gets.chomp).to_i
    puts "Card Color:"
    card << gets.chomp
    puts "Card Type:"
    card << gets.chomp
    puts "Is the card a Foil? Enter 1 for yes and 0 for no:"
    card << enter_valid_digit(gets.chomp).to_i
    puts "Card Price:"
    card << enter_valid_digit(gets.chomp).to_f
    puts "How many of this card would you like to remove from inventory?"
    card << enter_valid_digit(gets.chomp).to_i
    remove_card_from_inventory(card)
    puts "If the card's qty did not update you entered in the wrong info or the card is not in inventory."
  else
    puts "#{option} is not a valid choose, please try again."
  end
end

puts "Thank you for using the Inventory Portal, Good bye!"