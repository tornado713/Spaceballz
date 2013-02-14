module(..., package.seeall)

local storyboard = require( "storyboard" )

-- declare the class table first
local class_Paddle = {}

-- local variables and constants
local paddleDisplay
local WIDTH = 50
local HEIGHT = 5

-- constructor
function class_Paddle.new(sethp, initialx, initialy)		
	-- Build object and properties, physics, etc
	paddleDisplay = display.newRect(initialx, initialy, WIDTH, HEIGHT)
	
	paddleDisplay.width = WIDTH
	paddleDisplay.height = HEIGHT
	paddleDisplay.name = "paddle"
	paddleDisplay.hitPoints = sethp
	paddleDisplay.agility = 0.5
	
	paddleDisplay:setFillColor(255,255,255)
	
	physics.addBody(paddleDisplay, "static", {bounce = 1.2})
	
	-- Function Calls need to be added first for use in listeners
	function paddleDisplay:alterHp(hp)	
		self.hitPoints = self.hitPoints + hp
	end
	
	-- events need to be called after functions and before event listeners
	
	-- Event Listeners
	
	return paddleDisplay
end

return class_Paddle