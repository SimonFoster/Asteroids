require "vectors"
require "spaceship"
require "rocks"
require "bullets"
require "sounds"
require "after"

debug = true

math.randomseed( os.time() )


--[[
Large Asteroid: 20 points.
Medium Asteroid: 50 points.
Small Asteroid: 100 points.
Large Saucer: 200 points.
Small Saucer: 1,000 points.
--]]

local function tone()
	love.audio.play( 
		game.tone and sounds.tonehi or sounds.tonelo )
	game.tone = not game.tone
end

function love.load()

	after.every( 1, tone )
	love.mouse.setVisible( false )

	local vectorb = love.graphics.newFont( 'fonts/Vectorb.ttf', 15 )
	love.graphics.setFont( vectorb )

	-- love.graphics.setNewFont( 15 )
	
	game = {}

	game.screen = 1
	game.ships 	= 3
	game.score 	= 0

	game.objects = {}
	game.objects.bullets = {}
	game.objects.rocks = {}

	game.objects.ship = spaceship.spaceship:new()

end

local function updateObjects( objects, dt )
	for i = #objects, 1, -1 do
		local object = objects[i]
		if object.delete then 
			table.remove( objects, i )
		else
			object:update( dt )
		end
	end
end

function love.update( dt )

	if game.pause then return end

    after.update( dt )
    
	updateObjects( game.objects.rocks, dt )
	updateObjects( game.objects.bullets, dt )
	game.objects.ship:update( dt )

    if game.objects.ship then
    	if love.keyboard.isDown( 'left' ) then
    		game.objects.ship:rotate( -360 * dt )
    	end 

    	if love.keyboard.isDown( 'right' ) then
    		game.objects.ship:rotate( 360 * dt )
    	end 

    	if love.keyboard.isDown( 'up' ) then
    		game.objects.ship:thrust( 100 * dt )
    	end
    end

	if #game.objects.rocks == 0 then
		for i = 1, 10 do rocks.rock:new( { size=3 } ) end
		game.screen = game.screen + 1
	end

end

function love.draw()

	love.graphics.print( '© ATARI INC 1979', 330, 550 )
	love.graphics.print( game.score, 30, 20 )

	local base = vectors.vector:new( 30, 55 )

	for i = 1, game.ships do
		local poly = spaceship.newship()
		local p1, p2

		for i = 1, #poly - 1 do
			p1 = base + poly[i]
			p2 = base + poly[i+1]
			utils.vline( p1, p2 )
		end

		utils.vline( p2, base + poly[1] )
		base = base + vectors.vector:new( 10, 0 )
	end

	local bullets = game.objects.bullets
	local rocks   = game.objects.rocks
    local ship 	  = game.objects.ship 

	for i = 1, #bullets do bullets[i]:draw() end
	for i = 1, #rocks   do rocks[i]:draw() end
    
    if game.objects.ship then ship:draw() end

   	if game.ships == 0 then
   		love.graphics.print( 'GAME OVER', 350, 300 )
   	end

	if not game.osd then return end

	love.graphics.print( string.format(
		'S: %2d\nR: %2d\nB: %2d\nAngle: %3d\nV: %s\nFPS: %4d\ngarbage: %d',
			game.ships,
			#game.objects.rocks,
			#game.objects.bullets,
			ship.angle,
			tostring( ship.velocity ),
			love.timer.getFPS(),
			collectgarbage( 'count' ) ),
			680, 20 )

	--[[
	local globals = {}
	for k, v in pairs( _G ) do
		table.insert( globals,
			string.format( '%s = %s', tostring(k), tostring(v) ))
	end
	love.graphics.print( table.concat( globals, '\n' ), 40, 40 )
	--]]
end

function love.keypressed( key, unicode )

	-- print( key, unicode )

	if game.objects.ship then
		if		key == ' ' 		then game.objects.ship:hyperspace()
		elseif 	key == 'lctrl'	then game.objects.ship:shoot()
		end
	end

	if     	key == "escape" then love.event.quit()
	elseif	key == 'f2'		then game.osd = not game.osd
	elseif	key == 'p'		then game.pause = not game.pause

	elseif	key == '1' then
		game.objects.ship = spaceship.spaceship:new()
		game.ships = 3
		game.objects.rocks = {}
		game.score = 0
    end
end