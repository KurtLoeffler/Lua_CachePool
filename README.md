# Lua_CachePool
A lua library for creating pools of cached objects, intended to reduce garbage generation for high performance applications such as games.

## Example usage
```lua
-- import the CachePool type
CachePool = require("libraries.CachePool")

-- create an instance of it
pool = CachePool()

-- register pool type factories
-- first argument is the function name which will be prefixed with "get" (eg. pool:getVector3())
-- second argument is a function that is called to create new instances of the object to fill the pool when needed
-- third argument is a function that is called on each object that is returned from the pool:get***(), in this case initializing them to default values
pool:newTypePool("Vector3", function() return Vector3() end, function(v) v:set(Vector3.default) end)
pool:newTypePool("Vector4", function() return Vector4() end, function(v) v:set(Vector4.default) end)
pool:newTypePool("Quat", function() return Quat() end, function(v) v:set(Quat.default) end)
pool:newTypePool("Matrix4", function() return Matrix4() end, function(v) v:set(Matrix4.default) end)

-- game loop
...
-- get a Vector3 from the pool and make it a copy of rigidbody.velocity
local deltaPosition = pool:getVector3():set(rigidbody.velocity)
-- do some math with the pooled vector
deltaPosition:multiply(frameInfo.deltaTime)
transform.position:add(deltaPosition)
-- be sure not to keep references of pooled object because it may be used by some other user next frame
...

-- at the of the game frame, reset internal counters so pooled objects can be reused next frame
pool:reset()
```

## Requirements
This library is intended for use with the **middleclass** OOP library, with a global `class()` function or callable table declared. If `class()` is not declared, it will still work though.
