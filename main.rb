require_relative 'excel_manipulation'
require_relative 'db_manipulation'

module Due
  PATH = "./Orders.xlsx"

  # Display all the orders in the standard output
  def self.displayOrders(orders)
    orders.each_index do |order_index|
      puts "Order #{order_index + 1}:"
      order = orders[order_index]
      order.each_index do |pck_index|
        puts "  Package #{pck_index}:"
        pck = order[pck_index]
        pck.each do |item|
          puts "    #{item}"
        end
      end
    end
  end

  def self.main()
    begin
      workbook = Excel.new(PATH)

      # connection to the database
      con = DataBase.new("due", "due")

      # get all information of the xlsx file
      orders = workbook.fetchAll

      displayOrders orders

      # get the names of the orders
      data = workbook.fetchNames()

      con.insertOrders data
      con.insertPackages orders
      con.insertItems orders


    rescue RubyXL::ArgumentError => e
      puts e.message
    rescue PG::Error => e
      puts e.message
    ensure
      con.close if con
    end
  end
end

Due.main if __FILE__ == $PROGRAM_NAME
