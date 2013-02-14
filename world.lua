module(..., package.seeall)

---------------------------------------------------------------------------------
--
-- world.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local gameState = require("gamestate")
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local localGroup = display.newGroup()
local background, asteroid, planet, menuText

local function mobTouch(self, event)
	if event.phase == "began" then
		_G["monster"] = self.filename
		storyboard.gotoScene("game")
		return true
	end
end

local function menuTouch(self, event)
	if event.phase == "ended" then
		storyboard.gotoScene("gamemenu")
		return true
	end
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
print(gameState.xp)
	storyboard.purgeScene("backstory")
	storyboard.purgeScene("win")
	storyboard.purgeScene("gameover")
	
	local screenGroup = self.view
		
	background = display.newImage("Images/star-tile-far-away.png")
	screenGroup:insert(background)
	
	asteroid = display.newImage("Images/asteroid.png", 50, 50)
	asteroid.filename = "Lesser_Asteroid.txt"
	asteroid.touch = mobTouch
	screenGroup:insert(asteroid)
	
	planet = display.newImage("Images/neptune.png", 100, 250)
	planet.filename = "Lesser_Planet.txt"
	planet.touch = mobTouch
	screenGroup:insert(planet)
	
	menuText = display.newText("Menu", 30, 460, nil, 16)
	menuText.touch = menuTouch
	screenGroup:insert(menuText)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	asteroid:addEventListener("touch", asteroid)
	planet:addEventListener("touch", planet)
	menuText:addEventListener("touch", menuText)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	asteroid:removeEventListener("touch", asteroid)
	menuText:removeEventListener("touch", menuText)
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "((destroying world's view))" )
	background = nil
	asteroid = nil
	menuText = nil
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