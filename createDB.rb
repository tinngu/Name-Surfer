require 'sqlite3'

#filename should be changed, using another filename obviously
def readFile()
	#This is assuming the file name will be used
	filename = 'names-data.txt'
	open(filename, 'r') {|f| f.read}
end

#Converts 0's to 1001 from datafile "name-data.txt"
#NOTE: A 0 occurring as a rank means that the name did not appear in
# the top 1000 for that decade. This converts 0s to 1001.
def convertZeros(sect)
	result = Array.new
	sect = sect.to_s
	sect = sect.split("\n") #Each section separated by newline character
	sect.each do |str|
		str = str.downcase
		str = str.split(' ') # Then separating by space and converting
		str.map! do | x |
      (x == '0') ? x = '1001' : x
		end
		result.push(str)
	end
	result
end

#Sets up the database with years and names
begin
  db = SQLite3::Database.new 'Names.db'
  db.execute 'CREATE TABLE IF NOT EXISTS Names
  (ID INTEGER PRIMARY KEY AUTOINCREMENT,	Name STRING,
  year1900 INTEGER,
	year1910 INTEGER,
	year1920 INTEGER,
	year1930 INTEGER,
	year1940 INTEGER,
	year1950 INTEGER,
	year1960 INTEGER,
	year1970 INTEGER,
	year1980 INTEGER,
	year1990 INTEGER,
	year2000 INTEGER)'

	#Using the above functions
	convertZeros(readFile).each do |str|
		db.execute "INSERT INTO Names
    (Name,
		year1900,
		year1910,
		year1920,
		year1930,
		year1940,
		year1950,
		year1960,
		year1970,
		year1980,
		year1990,
		year2000)
		VALUES( '#{str[0]}' ,#{str[1, 11].join(',')})"

	end
	puts '**** The name database was successfully created! ****'
rescue SQLite3::Exception => error
	puts '**** An Error Occurred! ****'
	puts error
ensure
  db.close if db
end

