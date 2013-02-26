module(..., package.seeall)

require "sqlite3"

-- deblare the class table first
local db = {}

-- local variables and constants
local database

-- constructor
function db.new()
	local path = system.pathForFile("data.db", system.DocumentsDirectory)
	database = sqlite3.open(path)
	
	print("before execute")
	--function database:initialize()
		database:exec[[
			create table if not exists item (id integer primary key, name text, active integer);
		]]
			
			--insert into item (id, name, active) values (null, 'Diapers', 1);
		database:exec[[
			PRAGMA foreign_keys = ON;
			create table if not exists purchase (id integer primary key, 
				itemid REFERENCES item(id), date integer, amount integer, active integer);
				
			insert into purchase (id, itemid, date, amount, active) values (null, 2, DATETIME('now'), 33.30, 1);
		]]
	--end
	print("after execute")
	
	return database
end

return db