require_relative 'excel_manipulation'
require_relative 'db_manipulation'

module Due
  PATH = "./Orders.xlsx"

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
    workbook = Excel.new(PATH)
    begin
      con = PG.connect :dbname => 'due', :user => 'due'   #DataBase.new("due", "due")

      orders = workbook.fetchAll
      displayOrders orders

      pckId = 0
      itemId = 0

      data = workbook.fetchNames()

      con.insertOrders data

    rescue PG::Error => e
      puts e.message
    ensure
      con.close if con
    end
  end
end

Due.main if __FILE__ == $PROGRAM_NAME
