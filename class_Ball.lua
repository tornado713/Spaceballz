module(..., package.seeall)

-- deblare the class table first
local class_Ball = {}

-- local variables and constants
local ballDisplay
local RADIUS = 7

-- constructor
function class_Ball.new(sethp, initialx, initialy, isEnemy)	
	
	-- Build object and properties, physics, etc
	if (isEnemy == 0) then
		ballDisplay = display.newImageRect("Images/earth.png", 14, 14)
	else
		ballDisplay = display.newCircle(initialx, initialy, RADIUS)
		ballDisplay:setFillColor(255, 0, 0)
	end
	ballDisplay.x = initialx
	ballDisplay.y = initialy
	ballDisplay.name = "ball"
	ballDisplay.hitPoints = sethp
	ballDisplay.strength = 0;
	ballDisplay.element = "None"
	ballDisplay.elementStrength = 0
	ballDisplay.agility = 0.5
	
	--ballDisplay:setFillColor(255,255,255)
	physics.addBody(ballDisplay, {bounce = ballDisplay.agility, radius = RADIUS})
	
	-- Function Calls need to be added first for use in listeners
	function ballDisplay:alterHp(hp)	
		self.hitPoints = self.hitPoints + hp
	end
	
	-- events need to be called after functions and before event listeners
	-- local function blockHit (self, event)
		-- if event.other.name == "ball" and event.phase == "ended" then
			-- self:alterHp(-230)
			-- if self.hitPoints <= 0 then
				-- event.target:removeSelf()
			-- end
			-- print(self.hitPoints)
		-- end
	-- end
	
	-- Event Listeners
	-- ballDisplay.collision = blockHit
	-- ballDisplay:addEventListener("collision", ballDisplay)
	
	return ballDisplay
end

return class_Ball