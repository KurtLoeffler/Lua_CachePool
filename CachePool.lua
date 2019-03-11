local CachePool = class("CachePool")

function CachePool:initialize()
	self.pools = {}
end

function CachePool:reset()
	for k,v in pairs(self.pools) do
		v.count = 0
	end
end

function CachePool:newTypePool(name, newConstructor, initializer)
	local typePool = {
		pool = {},
		count = 0
	}
	self.pools[name] = typePool
	self["get"..name] = function(self, ...)
		local pool = self.pools[name]
		if pool.count >= #pool.pool then
			table.insert(pool.pool, newConstructor(...))
		end
		pool.count = pool.count+1
		local value = pool.pool[pool.count]
		if initializer then
			initializer(value, ...)
		end
		return value
	end
end

return CachePool
