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
	
	function database:initialize()
		self:exec[[
			create table item (id integer primary key, name, bool active);
			insert into item(null, 'Diapers', true);
			create table purchase (id integer primary key, itemid, date, amount, active);
		]]
	end
	
	return database
end


return db