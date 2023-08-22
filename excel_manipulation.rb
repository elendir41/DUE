require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'rubyXL/convenience_methods/color'
require 'rubyXL/convenience_methods/font'
require 'rubyXL/convenience_methods/workbook'
require 'rubyXL/convenience_methods/worksheet'
module Due


  class Excel
    def initialize(path)
      @path = path
      @workbook = RubyXL::Parser.parse(@path)
    end

    def worksheets
      @workbook.worksheets
    end

    def columns_at(worsheet, n)
      cols = []
      ws = @workbook[worsheet]

      ws.each do |row|
        cell = row[n]
        cols << cell.value if cell
      end
    end

    def fetchAll()
      orderCount = 0
      orders = []
      @workbook.worksheets.each do |ws|
        orders << []
        (1...ws.count).each do |row_index|
          currentOrder = orders[orderCount]
          row = ws[row_index]

          pckId = row[0].value

          currentOrder << [] if pckId >= currentOrder.length
          pck = currentOrder[pckId]

          itemId = row[1].value
          lable = row[2].value
          value = row[3].value

          pck << Hash.new('') if itemId >= pck.length
          pck[itemId][lable] = value
        end
        orderCount += 1
      end
      return orders
    end
  end

end
