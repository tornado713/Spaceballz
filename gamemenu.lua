module(..., package.seeall)

---------------------------------------------------------------------------------
--
-- gamemenu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local localGroup = display.newGroup()
local background, exitText, backText, statusText, saveText

local function statusTouch(self, event)
	if event.phase == "ended" then
		native.showAlert("SpaceBallz", "Feature not implemented yet")
		return true
	end
end

local function saveTouch(self, event)
	if event.phase == "ended" then
		native.showAlert("SpaceBallz", "Feature not implemented yet")
		return true
	end
end

local function backToWorldTouch(self, event)
	if event.phase == "ended" then
		storyboard.gotoScene("world")
		return true
	end
end

local function exitTouch(self, event)
	if event.phase == "ended" then
		os.exit()
		return true
	end
end
	
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	
	statusText = display.newText("Status", 30, 400, nil, 18)
	statusText.touch = statusTouch
	screenGroup:insert(statusText)
	
	saveText = display.newText("Save Game", 30, 420, nil, 18)
	saveText.touch = saveTouch
	screenGroup:insert(saveText)
	
	backText = display.newText("Back to World", 30, 440, nil, 18)
	backText.touch = backToWorldTouch
	screenGroup:insert(backText)
	
	exitText = display.newText("Exit Game", 30, 460, nil, 18)
	exitText.touch = exitTouch
	screenGroup:insert(exitText)
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	statusText:addEventListener("touch", statusText)
	saveText:addEventListener("touch", saveText)
	backText:addEventListener("touch", backText)
	exitText:addEventListener("touch", exitText)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	statusText:removeEventListener("touch", statusText)
	saveText:removeEventListener("touch", saveText)
	backText:removeEventListener("touch", backText)
	exitText:removeEventListener("touch", exitText)
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	exitText = nil
	backText = nil
	saveText = nil
	statusText = nil
	background = nil
	print( "((destroying gamemenu's view))" )
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