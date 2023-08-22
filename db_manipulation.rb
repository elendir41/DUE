require 'pg'

module Due
  class DataBase
    def initialize(dbname, user)
      begin
        @con = PG.connect :dbname => dbname, :user => user
      rescue PG::Error => e
        puts e.message
      end
    end

    def insertOrders(data)
      query = "INSERT INTO orders (orderid, odername) VALUES ($1, $2)"

      data.each do |values|
        @con.exec_params(query, values)
      end
    end


    def insertPackages(orders)
      query = "INSERT INTO packages (packageid, orderid) VALUES "
      values = []
      pckId = 0

      orders.each_with_index do |order, orderIndex|
        order.each_index do |_pckIndex|
          values << "(#{pckId}, #{orderIndex})"
          pckId += 1
        end
      end

      query += values.join(', ')
      @con.exec query
    end

    # insert all items found in the database
    # if some of fields are unknow they are replaced by 'unknown', 0 or false according to the type
    def insertItems(orders)
      query = "INSERT INTO items (itemid, name, price, ref, packageid, warranty, duration) VALUES "
      itemId = 0
      pckId = 0
      values = []
      orders.each_with_index do |order, orderIndex|
        order.each_with_index do |pck, pckIndex|
          pck.each do |item|
            item = item.transform_values do |value|
              if value.is_a?(String)
                "'#{value}'"
              else
                value
              end
            end
            values << "(#{itemId}, #{item['name'] ? item['name'] : "'unknown'" }, #{item['price'] ? item['price'] : "'unknown'"}, #{item['ref'] ? item['ref'] : "'unknown'"}, #{pckId}, #{item['warranty'] == "YES"}, #{item['duration'] ? item['duration'] : 0})"
            itemId += 1
          end
          pckId += 1
        end
      end

      query += values.join(', ')
      @con.exec query
    end

    def exec(query)
      @con.exec query
    end

    def close
      @con.close
    end
  end
end
