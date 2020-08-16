module( ..., package.seeall )

require "vectors"

polyline = {};

vec = vectors.vector

function polyline:new( points )
	-- populate the 'shape' polygon from template
	poly = {}
	if points then
		for i = 1,  #points do
			v = vec:new( unpack( points[i] ))
			table.insert( poly, v )
		end
	end
	self.__index = self
	return setmetatable( poly, self )
end

function polyline:scale( scl )
	poly = polyline:new()
	for i = 1,  #self do
		local v = scl * self[i] 
		table.insert( poly, v )
	end
	return poly
end

function polyline:translate( x, y )
	poly = polyline:new()
	for i = 1,  #self do
		local v = self[i] + vec:new( x, y )
		table.insert( poly, v )
	end
	return poly
end

function polyline:rotate( angle )
	poly = polyline:new()
	for i = 1,  #self do 
		local v = self[i]:rotate( angle )
		table.insert( poly, v )
	end
	return poly
end

function polyline:draw( offset )
	local p1, p2
	for i = 1, #self - 1 do
		p1 = offset + self[i]
		p2 = offset + self[i+1]
		utils.vline( p1, p2 )
	end
	utils.vline( p2, offset + self[1] )
end




