module( ..., package.seeall )

function vline( v1, v2 )
    local p1x, p1y = v1:unpack()
    local p2x, p2y = v2:unpack()
    love.graphics.line( p1x, p1y, p2x, p2y )
end

--[[
function tprint( x, n )
	if debug and x then
		print( x )
		if type( x ) == 'table' then
			local n = n or 0
			for k, v in pairs( x ) do
				print( n, string.rep( ' ', n ), k, ':', v )
			end
			local mt = getmetatable( x )
			tprint( mt, n+1 )
		end
		print '----'
	end
end

function values( tbl )
	local i = 0
	return function() i = i + 1; return tbl[i] end
end

function map( func, tbl )
    local newtbl = {}
    for v in values( t ) do table.insert( newtbl, func( v )) end
    return newtbl
end
--]]

