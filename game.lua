module(..., package.seeall)

require("physics")

---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local localGroup = display.newGroup()
local gameState = require("gamestate")
local Block = require "class_Block"
local Ball = require "class_Ball"
local Paddle = require "class_Paddle"
local paddle, ball, bottom, enemyTimer, hpDisplay
local enemyBallGroup
local background

local function movePaddle(self, event)
	transition.to(paddle, {time=.1,  x=event.x + 10, y = 450, transition=easing.inOutExpo})
	return true
end

local function paddleHit (self, event)
	if event.other.name == "ball" and event.phase == "began" then
		local width = self.width / 4
		local currentX, currentY = event.other:getLinearVelocity()
		if event.other.x > (self.x + width) then
			event.other:setLinearVelocity(currentX + 80, currentY)
		end			
		if event.other.x < (self.x - width) then
			event.other:setLinearVelocity(currentX - 80, currentY)
		end
	end
	if event.other.name == "enemyBall" and event.phase == "ended" then
		self:alterHp(-100)
		hpDisplay.text = "HP: " .. self.hitPoints
		if self.hitPoints <= 0 then
			storyboard.gotoScene("gameover")
		end
	end
	return true
end

local function ballEvent(self, event)
	if event.other.name == "enemyBall" then
		event.other:removeSelf()
		return true
	end
end

-- explode(separator, string)
function explode(d,p)
	local t, ll
	t={}
	ll=0
	if(#p == 1) then return {p} end
		while true do
		l=string.find(p,d,ll,true) -- find the next d in the string
		if l~=nil then -- if "not not" found then..
			table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
			ll=l+1 -- save just after where we found it for searching next time.
		else
			table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
			break -- Break at end, as it should be, according to the lua manual.
		end
	end
	ll = nil
	return t
end
 
local function buildGameBoard()
	local blockGroup = display.newGroup()
	local blockTable = {}
	local newTable = {}
	local count = 0
	-- build table with 1s, 0s (2s are core)
	
	local path = system.pathForFile("Mobs/" .. _G["monster"])
	local fh, reason = io.open(path,"r")
	 
	if fh then
		for fileline in fh:lines() do
			newTable = explode(",", fileline)
			count = count + 1
			if count < 2 then
				gameState.monsterxp = newTable[1]
				gameState.monstermoney = newTable[2]
			else
				
				table.insert(blockTable, newTable)
			end
		end
	else
		print( "Reason open failed: " .. reason ) 
	end
	 
	fh:close()
	
	-- iterate over table and build block structure based on it
	for i,line in ipairs(blockTable) do
    	for j,line2 in ipairs(line) do
      		if (line2 == "1") then
      			block = Block.new(500, j * 25, i * 10 + 25, 0, 0, 255, 0)
				blockGroup:insert(block)
  			end
  			if (line2 == "2") then
  				block = Block.new(500, j * 25, i * 10 + 25, 255, 0, 0, 1)
				blockGroup:insert(block)
			end
		end
    end
	-- remove table from memory (nil)
	newTable = nil
	blockTable = nil
	count = nil
	fh, reason = nil
	
	return blockGroup
end
	
-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	
	physics.start()
	background = display.newImage("Images/star-tile-far-away.png")
	background.touch = movePaddle
	screenGroup:insert(background)
	
	physics.setGravity(0, 4)
	
	--physics.setDrawMode("hybrid")
	
	local leftwall = display.newRect(24, 0 , 1, display.contentHeight)
	local rightwall = display.newRect(display.contentWidth - 25, 0 , 1, display.contentHeight)
	local ceiling = display.newRect(0, -1 , display.contentWidth, 1)
	bottom = display.newRect(0, display.contentHeight , display.contentWidth, 1)
		
	bottom.collision = ballEvent
	
	physics.addBody(leftwall, "static", {bounce = 1})
	physics.addBody(rightwall, "static", {bounce = 1})
	physics.addBody(ceiling, "static", {bounce = 0.5})
	physics.addBody(bottom, "static", {bounce = 1})
	
	screenGroup:insert(buildGameBoard())
	
	paddle = Paddle.new(500, 150, 450)
	paddle.collision = paddleHit
	screenGroup:insert(paddle)
	
	hpDisplay = display.newText("HP: " .. paddle.hitPoints, 25, display.contentHeight - 15, nil, 14)
	screenGroup:insert(hpDisplay)
	
	ball = Ball.new(100, 100, 200, 0)
	screenGroup:insert(ball)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene(event)
	-- loop every 10 sec, create enemy ball and when hits paddle, dmg occurs
	local function listener( event )
		enemyBallGroup = self.view
		local newBall = Ball.new(100, 100, 200, 1)
		newBall.name = 'enemyBall'
		enemyBallGroup:insert(newBall)
		newBall:applyForce(math.random()-.6, math.random()-.6, newBall.x, newBall.y)
	end
 
	enemyTimer = timer.performWithDelay(5000, listener, 0)
	
	paddle:addEventListener("collision", paddle)
	bottom:addEventListener("collision", bottom)
	background:addEventListener("touch", background)
	ball:applyForce(math.random()-.6, math.random()-.6, ball.x, ball.y)
	storyboard.purgeScene("world")
	storyboard.purgeScene("gamemenu")
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	print( "((exit game's view))" )
	-- remove event listeners
	enemyBallGroup = nil
	timer.cancel(enemyTimer)
	bottom:removeEventListener("collision", bottom)
	background:removeEventListener("touch", background)
end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "((destroying game's view))" )
	-- null objects and remove them from the group 
	enemyTimer = nil
	paddle = nil
	ball = nil
	block = nil
	block2 = nil
	block3 = nil
	block4 = nil
	leftwall = nil
	rightwall = nil
	ceiling = nil
	bottom = nil
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