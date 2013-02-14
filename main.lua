-- hides the status bar while app is running
display.setStatusBar (display.HiddenStatusBar)


local storyboard = require "storyboard"
local widget = require "widget"

-- local monitorMem = function()
    -- collectgarbage()
    -- print( "MemUsage: " .. collectgarbage("count") )
    -- local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
    -- print( "TexMem:   " .. textMem )
-- end
--Runtime:addEventListener( "enterFrame", monitorMem ) 

-- load first screen
storyboard.gotoScene( "menu" )