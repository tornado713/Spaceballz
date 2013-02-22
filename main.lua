-- hides the status bar while app is running
display.setStatusBar (display.HiddenStatusBar)


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

-- require "sqlite3"
-- local path = system.pathForFile("data.db", system.ResourceDirectory)
-- db = sqlite3.open(path)

 -- --Handle the applicationExit event to close the db
-- local function onSystemEvent( event )
        -- if( event.type == "applicationExit" ) then              
            -- db:close()
        -- end
-- end

-- db:exec[[
  -- create table if not exists test (id integer primary key, content);
  -- insert into test values (null, 'hello world');
  -- insert into test values (null, 'hello lua');
  -- insert into test values (null, 'hello sqlite3')
-- ]]
 
-- --print( "version " .. sqlite3.version() )
 
-- for row in db:nrows("SELECT * FROM test") do
  -- local t = display.newText(row.content, 20, 30 * row.id, null, 16)
  -- t:setTextColor(255,0,255)
-- end

-- db:close()

local json = require "json"
local function networkListener( event )


        if ( event.isError ) then
                print( "Network error!")
        else
                obj=event.response
                --display.newText(json.decode(event.response), 20, 30, null, 16)
                print ( "RESPONSE: " .. event.response )
        end
end

headers = {}
headers["Authorization"] = "Basic XXXXXXXX"
local params = {}
params.headers = headers


network.request( 'http://personaldb31bafdcc.nuvolabase.com/query/db$free$tornado713$Spaceballz/sql/select+XXX+from+test+limit+10', "GET", networkListener,params )