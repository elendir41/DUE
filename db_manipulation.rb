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
        con.exec_params(query, values)
      end
    end
  end
end
