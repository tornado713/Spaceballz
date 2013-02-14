module(..., package.seeall)

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- deblare the class table first
local class_Block = {}

-- local variables and constants
local blockDisplay, g, hpDisplay
local WIDTH = 25
local HEIGHT = 10

-- constructor
function class_Block.new(sethp, initialx, initialy, red, green, blue, isCore)	
	
	-- Build object and properties, physics, etc
	blockDisplay = display.newRect(initialx, initialy, WIDTH, HEIGHT)
	blockDisplay.hitPoints = sethp
	blockDisplay.x = initialx
	blockDisplay.y = initialy
	blockDisplay.isCore = isCore;
	blockDisplay.element = "None"
	blockDisplay.elementStrength = 0
	
	g = graphics.newGradient(
		  { 139, 137, 137 },
		  { 49, 79, 79 },
		  "down" )
		  
	if (isCore == 1) then
		g = graphics.newGradient(
		  { 255, 0, 0 },
		  { 178, 34, 34 },
		  "down" )
		hpDisplay = display.newText("Core: " .. blockDisplay.hitPoints, display.contentWidth - 100, display.contentHeight - 15, nil, 14)
	end
	
	blockDisplay:setFillColor(g)
	physics.addBody(blockDisplay, "static", {bounce = -.2})
	
	-- Function Calls need to be added first for use in listeners
	function blockDisplay:alterHp(hp)	
		self.hitPoints = self.hitPoints + hp
	end
	
	function blockDisplay:removeHpDisplay()
		hpDisplay:removeSelf()
		hpDisplay = nil
	end
	
	-- events need to be called after functions and before event listeners
	local function blockHit (self, event)
		if event.other.name == "ball" and event.phase == "ended" then
			if (self.isCore == 1) then
				self:alterHp(-250)
				hpDisplay:removeSelf()
				if (self.hitPoints > 0) then
					hpDisplay = display.newText("Core: " .. self.hitPoints, display.contentWidth - 100, display.contentHeight - 15, nil, 14)
				end
			else
				self:alterHp(-500)
			end
			if self.hitPoints <= 0 then
				event.target:removeSelf()
				if (self.isCore == 1) then
					storyboard.gotoScene("win")
				end
			end
			return hpDisplay
		end
	end
	
	-- Event Listeners
	blockDisplay.collision = blockHit
	blockDisplay:addEventListener("collision", blockDisplay)
	
	return blockDisplay
end

return class_Block