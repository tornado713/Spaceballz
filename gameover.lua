module(..., package.seeall)

---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

require("physics")
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local localGroup = display.newGroup()
local gameState = require("gamestate")
local background

local function resetTouch(self, event)
	if event.phase == "began" then
		
		storyboard.gotoScene("menu")
		
		return true
	end
end
	
-- Called when the scene's view does not exist:
function scene:createScene( event )
	storyboard.purgeScene("game")
	local screenGroup = self.view
		
	background = display.newImage("Images/blackbackground.png")
	background.touch = resetTouch
	screenGroup:insert(background)
	
	local text = display.newText("Game Over!!", 70, 200, nil, 20)
	screenGroup:insert(text)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	background:addEventListener("touch", background)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	print( "1: exit gameover event" )
	background:removeEventListener("touch", background)
	physics.stop()
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "((destroying gameover's view))" )
	background = nil
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene