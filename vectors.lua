module( ..., package.seeall )

local rad = math.rad
function sin(x) return math.sin( rad(x) ) end
function cos(x) return math.cos( rad(x) ) end

vector = {}

function vector:new( x, y )
	local vec = { x = x, y = y }
	setmetatable( vec, self )
	self.__index = self
	return vec
end

function vector:polar( angle, r )
    local r = r or 1
	return vector:new( r * cos( angle), r * sin( angle ))
end

function vector:copy()
    return vector:new( self.x, self.y )
end

function vector:unpack()
	return self.x, self.y
end

function vector:len()
    return math.sqrt( self.x * self.x + self.y * self.y )
end
 
 function vector:rotate( angle )
    local c = cos( angle )
    local s = sin( angle )
    local x, y = self.x, self.y
    self.x = c * x - s * y
    self.y = s * x + c * y
    return self
end

function vector:wrap()

    local function wrap( p, min, max )
        if p > max then return p - max end
        if p < min then return max - p end
        return p
    end

    local x = wrap( self.x, 0, love.graphics.getWidth()  )
    local y = wrap( self.y, 0, love.graphics.getHeight() )

    return vector:new( x, y )
end

function vector.__add( op1, op2 )
    if getmetatable(op1) == vector
        and getmetatable(op2) == vector then
        return vector:new( op1.x + op2.x, op1.y + op2.y )
    end
    error( 'Both operands must be vectors', op1 .. ',' .. op2 )
end

function vector.__sub( op1, op2 )
    if getmetatable(op1) == vector
        and getmetatable(op2) == vector then
        return vector:new( op1.x - op2.x, op1.y - op2.y )
    end
    error( 'Both operands must be vectors', op1 .. ',' .. op2 )
end

function vector.__mul( op1, op2 )
    if getmetatable(op1) == vector
        and type(op2) == 'number' then
        return vector:new( op1.x * op2, op1.y * op2 )
    elseif getmetatable(op2) == vector
        and type(op1) == 'number' then
        return vector:new( op1 * op2.x, op1 * op2.y )
    else
        error( 'Not a vector', op1 .. ',' .. op2 )
    end
end

function vector.__div( op1, op2 )
    if getmetatable(op1) == vector
        and type(op2) == 'number' then
        return vector:new( op1.x / op2, op1.y / op2 )
    else
        error( 'Not a vector', op1 .. ',' .. op2 )
    end
end

function vector:__tostring()
	return '(' .. string.format( '%d', self.x )
        .. ',' .. string.format( '%d', self.y ) .. ')'
end


