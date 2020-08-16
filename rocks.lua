module( ..., package.seeall )

require "vectors"
require "utils"
require "polyline"

local rocks = {
	{{3,0},{6,0},{10,3},{9,5},{10,7},{7,10},{5,8},{3,10},{0,8},{0,3}},
	{{2,0},{5,4},{5,0},{7,0},{10,4},{10,7},{8,10},{4,10},{0,7},{3,6},{0,4}},
	{{3,0},{4,2},{7,0},{10,3},{7,6},{10,8},{7,10},{5,8},{2,10},{0,8},{2,5},{0,2}}
}

rock = {};

rock.mass  = { 1, 2, 5 }
rock.value = { 100, 50, 20 }

function rock:new( o )

	local vec = vectors.vector

	local function newpos()
		if math.random(2) == 1 then 
			return vec:new( math.random(800), 0 )
		else 
			return vec:new( 0, math.random(600) )
		end
	end
 
	local function newvelocity()
		return vec:polar( math.random( 360 ), math.random( 20, 80 )) 
	end

	local o = o or {}
	
	o.size 		= o.size or math.random(3)
	o.position 	= o.position or newpos()
	o.velocity 	= o.velocity or newvelocity()

	o.value  	= rock.value[o.size]
	o.mass   	= rock.mass[o.size]
	o.radius 	= 5 * o.size
	o.angle     = 0
	o.rotate    = math.random( -10, 10 ) / 100

	local poly  = polyline.polyline:new( rocks[math.random(#rocks)] )
	poly 		= poly:translate( -5, -5 )
	poly 		= poly:scale( o.size )
	poly 		= poly:rotate( math.random(360) )
	o.poly = poly

	setmetatable( o, self )
	self.__index = self

	table.insert( game.objects.rocks, o )
	return o 
end


function rock:update( dt )
	self.position = self.position + self.velocity * dt
	self.position = self.position:wrap()
	self.angle = self.angle + self.rotate * dt
	self.poly = self.poly:rotate( self.angle )
	return self
end

function rock:draw( dt )
	self.poly:draw( self.position )
	return self
end

function rock:destroy()
	self.delete = true
	game.score = game.score + rock.value[self.size]
	if self.size > 1 then

		-- create two new rocks but preserve momentun
		local p, p1, p2
		local v1, v2
		local size = self.size - 1
		local mass = rock.mass[size]

		p  = self.mass * self.velocity

		-- Rock #1 carries off some random fraction 
		-- (between 80% and 100%) of the momentum
		p1 = p * math.random( 20, 80 ) / 100

 		-- Calculate velocity, give it a random rotation
 		-- then re-calculate the momentum
 		v1 = p1  / mass
		v1:rotate( math.random( -45, 45 ))
		p1 = mass * v1

		-- Create rock #1
		rock:new{
			position = self.position,
			size     = size,
			velocity = v1
		}

		-- Calculate momentum and velocity for Rock #2
		p2 = p - p1
		v2 = p2 / mass

		-- Create rock #2
		rock:new{
			position = self.position,
			size     = size,
			velocity = v2
		}

	end
end