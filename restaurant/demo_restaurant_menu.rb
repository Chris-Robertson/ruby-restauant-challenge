require 'terminal-table'

class MenuItem
  def initialize(name, price, category, description, options = '')
    @name = name
    @price = price
    @category = category
    @description = description
    @options = options
  end

  attr_accessor :name, :price, :category, :description, :options
end

class Order
  def initialize()
    @items = []
    @payment
  end

  attr_accessor :options

  def << (menu_item)
    @items << menu_item
  end

  def total
    total = 0
    @items.each do |item|
      total += item.price
    end
    total *= 1.015 if @payment == 2
    total
  end

  def bill
    puts 'How are you paying?'
    puts '1. Cash'
    puts '2. Card (1.5% surcharge)'
    puts
    loop do
      puts 'Selection:'
      @payment = gets.chomp
      @payment = @payment.to_i

      break if @payment == 1 || @payment == 2
    end

    table = Terminal::Table.new headings: ['Name', 'Price'] do |t|
      @items.each do |item|
        t << [item.name, "$#{item.price}"]
      end
      t.add_separator
      t << ['Surcharge', "$#{(total * 0.015).round(2)}"] if @payment ==2 
      t << ['TOTAL', "$#{total.round(2)}"]
    end
    table
  end
end

MENU_ITEMS = [
  MenuItem.new('Steak', 20, 'Main', 'Moooooo'),
  MenuItem.new('Parma', 15, 'Main', 'Chicken, apparently'),
  MenuItem.new('Eggplant Casserole', 15, 'Main', 'Looks nothing like an egg'),
  MenuItem.new('Chips', 7, 'Entree', 'Greasy deliciousness'),
  MenuItem.new('Ice Cream', 6, 'Dessert', 'Watch out for headaches'),
  MenuItem.new('Beer', 7, 'Drinks', 'Frothy'),
  MenuItem.new('Wine', 7, 'Drinks', 'Red AND White!'),
  MenuItem.new('Martini', 15, 'Drinks', 'The old silver bullet'),
  MenuItem.new('Negroni', 15, 'Drinks', 'The bartender’s concktail'),
  MenuItem.new('Manhattan', 15, 'Drinks', 'For the American pallete'),
  MenuItem.new('Sidecar', 15, 'Drinks', 'Viva la resistance!'),
  MenuItem.new('Gibson', 15, 'Drinks', 'The Tony Abbot special'),
  MenuItem.new('Screwdriver', 15, 'Drinks', 'Its just vodka and orange...'),
]

order = Order.new

# Main Menu
loop do
  puts '-----------------------------'
  puts 'Welcome to Fancy Restaurant'
  puts 'Please select an option below'
  puts
  puts '1. View Menu'
  puts '2. Place Order'
  puts '3. Get Bill'
  puts
  puts 'Selection:'
  menu_choice = gets.chomp
  menu_choice = menu_choice.to_i

  if menu_choice == 1
    # Display menu
    puts '-----------------------------'
    puts 'MENU'
    puts
    puts 'Please select from the submenu'
    puts
    puts '1. Entree'
    puts '2. Main'
    puts '3. Dessert'
    puts '4. Drinks'
    puts
    loop do
      puts 'Selection:'
      submenu_choice = gets.chomp
      submenu_choice = submenu_choice.to_i

      submenu = case submenu_choice
        when 1 then 'Entree'
        when 2 then 'Main'
        when 3 then 'Dessert'
        when 4 then 'Drinks'
        else next
      end
                  
      puts '-----------------------------'
      puts "#{submenu.upcase} MENU"
      MENU_ITEMS.each_with_index do |menu_item, index|
        next unless menu_item.category == submenu
        user_index = index + 1
        # Display item with index first, then name and price
        puts "#{user_index}. #{menu_item.name}: $#{menu_item.price} -- #{menu_item.description}"
      end
      puts
      break
    end

  elsif menu_choice == 2
    loop do
      puts 'What would you like?'
      choice = gets.chomp
      # Stop looping if user pressed just enter
      break if choice == ""

      # User must choose an index number
      user_index = choice.to_i

      # If the user entered in an invalid choice
      if user_index == 0
        puts 'Invalid choice, please try again'
        next # Loop through and ask again
      end

      index = user_index - 1 # Convert to zero-based index
      menu_item = MENU_ITEMS[index]

      puts "Any options? (enter for 'No')"
      options = gets.chomp
      menu_item.options = options

      # Add item to order
      puts
      puts "You have ordered the #{menu_item.name}, #{menu_item.options}"
      puts
      order << menu_item
    end
  elsif menu_choice == 3
    puts 'I hope you enjoyed your meal. Here is your bill:'
    puts order.bill
    puts 'Please come again'
    exit(1)
  else
    puts 'Invalid choice, please try again'
  end
end
