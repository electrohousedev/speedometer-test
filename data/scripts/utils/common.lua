
local M = {}

function M.new( object )
	local obj = object[1]
	for k,v in pairs(object) do
		if not (k==1) then
			obj[k]=v
		end
	end
	return obj
end

function M.pause( timeout )
  return coroutine.yield(timeout)
end

function M.class(base)
  -- "cls" is the new class
  local cls = {}
  local base = base or {}
  -- copy base class contents into the new class
  for k, v in pairs(base) do
    cls[k] = v
  end
  -- set the class's __index, and start filling an "is_a" table that contains this class and all of its bases
  -- so you can do an "instance of" check using my_instance.is_a[MyClass]
  cls.__index, cls.is_a = cls, {[cls] = true}
  for c in pairs(base.is_a or {}) do
    cls.is_a[c] = true
  end
  cls.is_a[base] = true
  cls.baseclass = base
  -- the class's new metamethod
  function cls:new(...)
     local instance = setmetatable({}, self)
      -- run the init method if it's there
      local init = instance._init
      if init then init(instance, ...) end
      return instance
  end
  -- return the new class table, that's ready to fill with methods
  return cls
end

return M
