module( ..., package.seeall )

require "vectors"
require "sounds"
require "bullets"
require "after"
require "polyline"

spaceship = {}

local ship_template = {{ 10, 0 },{ -7, 4 },{ -5, 2.5 },{ -5, -2.5 },{ -7, -4 }}

function spaceship:new()

	local ship = {}

	ship.position = vectors.vector:new( 400, 300 )
	ship.velocity = vectors.vector:new( 0, 0 )
	ship.angle = 0
	ship.size = 5
	ship.poly = polyline.polyline:new( ship_template )

	setmetatable( ship, self )
	self.__index = self
	return ship
end


function spaceship:update( dt )

	self.position = self.position + self.velocity * dt
	self.position = self.position:wrap()

    -- allow for some kind of drag.  This *must* depend on dt
	-- delta_v = a * delta_t

	local a = -0.1 * self.velocity 
	local delta_v = a * dt
    self.velocity = self.velocity + delta_v

   	local rocks = game.objects.rocks
	for i = #rocks, 1, -1 do
		if ( self.position - rocks[i].position ):len() 
								< rocks[i].radius
		then
			self:destruct()
			rocks[i].delete = true
		end
	end 


end

function newship( angle )
	local angle = angle or -90 
	local vec = vectors.vector
	return {
		vec:polar( angle, 		10 ),
		vec:polar( angle + 150, 8  ),
		vec:polar( angle + 155, 6  ),
		vec:polar( angle + 205, 6  ),
		vec:polar( angle + 210, 8  ),
	}
end

function spaceship:draw()
	self.poly:draw( self.position )
	return self
end

function spaceship:rotate( angle )
	self.poly  = self.poly:rotate( angle )
	self.angle = self.angle + angle
	return self
end

function spaceship:thrust( delta )
	local delta_v = vectors.vector:polar( self.angle, delta )
	self.velocity = self.velocity + delta_v
	return self
end

function spaceship:shoot()
	if #game.objects.bullets < 10 then
	    love.audio.play( sounds.shoot )
    	bullets.bullet:new{
    		angle    	= self.angle,
    		velocity 	= self.velocity + vectors.vector:polar( self.angle, 300 ),
    		position 	= self.position,
    		length	 	= 2,
    		range		= 500 }
    end
end

function spaceship:hyperspace()
	local rand = math.random
	local vec  = vectors.vector
	self.position = vec:new( rand(800), rand(600) )
	self.velocity = vec:new( 0, 0 )
	if math.random() > 0.8 then 
		self:destruct()
	end
end

function spaceship:destruct()

	if game.ships > 0 then
		game.ships = game.ships - 1
		game.objects.ship  = nil
		after.after( 3, 
			function() 
				game.objects.ship = spaceship:new()
			end )
	end

	for i = 1, 3 do
		local angle = math.random( 360 )
    	bullets.bullet:new{
    		angle    	= angle,
    		velocity 	= vectors.vector:polar( angle, 100 ),
    		position 	= self.position,
    		length	 	= 10,
    		range		= 30 }
	end
end