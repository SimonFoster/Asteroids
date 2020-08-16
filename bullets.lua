module( ..., package.seeall )

require "vectors"
require "utils"

bullet = {}

function bullet:new( bullet )

	bullet.p2		= vectors.vector:polar( 
						bullet.angle, bullet.length  )
	bullet.tacho 	= vectors.vector:new( 0, 0 )

	setmetatable( bullet, self )
	self.__index = self

	table.insert( game.objects.bullets, bullet )
	return bullet
end

function bullet:update( dt )

	local delta = self.velocity * dt
	self.position = self.position + delta
	self.position = self.position:wrap()

	self.tacho = self.tacho + delta

	if self.tacho:len() > self.range then self.delete = true end

	local rocks = game.objects.rocks
	for i = #rocks, 1, -1 do
		if ( self.position - rocks[i].position ):len() < rocks[i].radius then
			rocks[i]:destroy()
			self.delete = true
			-- love.audio.play( sounds.explode )
		end
	end 

end

function bullet:draw()
	local p1 = self.position
	local p2 = self.position + self.p2
	utils.vline( p1, p2 )
end
