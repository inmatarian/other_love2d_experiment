-- OBJECT.LUA
-- 

module(..., package.seeall)

local object = getfenv()

function object:subclass( inst )
  inst = inst or {}
  setmetatable( inst, self )
  self.__index = self
  return inst
end

function object:new(...)
  local inst = self:subclass()
  if inst.init then inst:init(...) end
  return inst
end

function object:init()
  --
end

function object:superinit( class, ... )
  getmetatable( class ).init( self, ... )
end

