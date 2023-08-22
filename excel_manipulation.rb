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

    def fetchAll()
      orderCount = 0
      orders = []
      @workbook.worksheets.each do |ws|
        orders << []
        # skip the titles row
        (1...ws.count).each do |row_index|
          currentOrder = orders[orderCount]
          row = ws[row_index]

          pckId = row[0].value

          # add a package if we found a new one
          currentOrder << [] if pckId >= currentOrder.length
          pck = currentOrder[pckId]

          itemId = row[1].value
          lable = row[2].value
          value = row[3].value

          # add an item if we found a new one
          pck << Hash.new(nil) if itemId >= pck.length
          pck[itemId][lable] = value
        end
        orderCount += 1
      end
      return orders
    end

    def fetchNames()
      data = []
      @workbook.each_with_index do |ws, index|
        data << [index, ws.sheet_name]
      end
      return data
    end
  end

end
