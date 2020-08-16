module( ..., package.seeall )

timenow = 0
events  = {}

function _enqueue( event )
  	table.insert( events , event )
 	table.sort( events, function( a, b ) return a.t < b.t end )
end

function _event( t, f )
	assert( t and f )
	local event = {}
	event.t = timenow + t
	event.f = f
	return event
end 

function every( t, f )
	assert( t and f )
	local event = _event( t, f )
	event.period = t
  	_enqueue( event )
end

function after( t, f )
	assert( t and f )
  	_enqueue( _event( t, f ))
end

function update( dt )
	timenow = timenow + dt
	while #events > 0 and events[1].t <= timenow do
		local event = table.remove( events, 1 )
		event.f()
		if event.period then
			event.t = timenow + event.period
			_enqueue( event )
		end
  	end
end