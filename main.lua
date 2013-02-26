-- hides the status bar while app is running
display.setStatusBar (display.HiddenStatusBar)

local database = require "db"

local function initialize(self, event)
	self:initialize()
end

local db = database.new()
db:initialize()

local function onSystemEvent( event )
        if( event.type == "applicationExit" ) then              
            db:close()
        end
end

for row in db.database:nrows("SELECT * FROM item") do
  local t = display.newText(row.name, 20, 30 * row.id, null, 16)
  t:setTextColor(255,0,255)
end

--local storyboard = require "storyboard"
--local widget = require "widget"

-- local monitorMem = function()
    -- collectgarbage()
    -- print( "MemUsage: " .. collectgarbage("count") )
    -- local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
    -- print( "TexMem:   " .. textMem )
-- end
--Runtime:addEventListener( "enterFrame", monitorMem ) 

-- load first screen
--storyboard.gotoScene( "menu" )
