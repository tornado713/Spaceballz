module(..., package.seeall)

---------------------------------------------------------------------------------
--
-- backstory.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local localGroup = display.newGroup()
local background

local function startGameTouch(self, event)
	if event.phase == "began" then
		storyboard.gotoScene("world")
		return true
	end
end

local function autoWrappedText(text, font, size, color, width)
        if text == '' then return false end
 
        font = font or native.systemFont
        size = tonumber(size) or 12
        color = color or {255, 255, 255}
        width = width or display.contentWidth
 
        local result = display.newGroup()
        local currentLine = ''
        local currentLineLength = 0
        local lineCount = 0
        local left = 0
        for line in string.gmatch(text, "[^\n]+") do
                for word, spacer in string.gmatch(line, "([^%s%-]+)([%s%-]*)") do
                        local tempLine = currentLine..word..spacer
                        local tempDisplayLine = display.newText(tempLine, 0, 0, font, size)
                        if tempDisplayLine.width <= width then
 
                                currentLine = tempLine
                                currentLineLength = tempDisplayLine.width
 
                        else
                                local newDisplayLine = display.newText(currentLine, 0, (size * 1.3) * (lineCount - 1), font, size)
                                newDisplayLine:setTextColor(color[1], color[2], color[3])
                                result:insert(newDisplayLine)
                                lineCount = lineCount + 1
                                if string.len(word) <= width then
 
                                        currentLine = word..spacer
                                        currentLineLength = string.len(word)
                                else
                                        local newDisplayLine = display.newText(word, 0, (size * 1.3) * (lineCount - 1), font, size)
                                        newDisplayLine:setTextColor(color[1], color[2], color[3])
                                        result:insert(newDisplayLine)
                                        lineCount = lineCount + 1
                                        currentLine = ''
                                        currentLineLength = 0
                                end 
                        end
                tempDisplayLine:removeSelf();
                tempDisplayLine=nil;
                end
                local newDisplayLine = display.newText(currentLine, 0, (size * 1.3) * (lineCount - 1), font, size)
                newDisplayLine:setTextColor(color[1], color[2], color[3])
                result:insert(newDisplayLine)
                lineCount = lineCount + 1
                currentLine = ''
                currentLineLength = 0
        end
        result:setReferencePoint(display.CenterReferencePoint)
        return result
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	storyboard.purgeScene("menu")
	local screenGroup = self.view
		
	background = display.newImage("Images/blackbackground.png")
	background.touch = startGameTouch
	screenGroup:insert(background)
	local text = "The galaxy has been in turmoil for eons.  " ..
		"Spirits have invaded cosmic bodies, causing " ..
		"entire solar systems to suffer.  " ..
		"You have been granted the power to fight " ..
		"these spirits, and must restore balance " ..
		"to the galaxy."
	
	local wrappedText = autoWrappedText(text, nil, 20, nil, 260)
	wrappedText.x = 160
	wrappedText.y = 130
	screenGroup:insert(wrappedText)
	
	text = nil
	wrappedText = nil
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	background:addEventListener("touch", background)
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	background:removeEventListener("touch", background)
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "((destroying scene backstory's view))" )
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