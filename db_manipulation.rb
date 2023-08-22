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
  end
end

=begin

begin

  rs = con.exec 'SELECT * FROM items' do |result|
    result.each do |row|
      puts "row"
      puts row.values
    end
  end

rescue PG::Error => e

  puts e.message

ensure
  rs.clear if rs
  con.close if con

end
=end
