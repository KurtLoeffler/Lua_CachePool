
local classFunc = class

if not classFunc then
	classFunc = function()
		local classType = {}
		setmetatable(classType, classType)
		classType.__index = classType
		function classType:__call(...)
			local instance = setmetatable({}, self)
			instance:initialize(...)
			return instance
		end
		return classType
	end
end

local CachePool = classFunc("CachePool")

function CachePool:initialize()
	self.pools = {}
end

function CachePool:reset()
	for k,v in pairs(self.pools) do
		v.count = 0
	end
end

function CachePool:newPool(name, newConstructor, initializer)
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
