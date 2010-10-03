-- friend Module

require "object"

module(..., package.seeall)

friend = object:subclass( getfenv() )

-- The friend class is a singleton, access via friend.instance()
local singleton_instance = nil;

function instance()
  return singleton_instance
end

-- The class houses a null state.
friend.state = { update = function() end }

function friend:init()
  self:superinit( friend )

  assert( singleton_instance == nil )
  singleton_instance = self

  love.update = function(dt) self:update(dt) end
  love.draw = function() self:draw() end
end

function friend:draw()
  self.state:draw()
end

function friend:update( dt )
  self.dt = dt
  self.state:update(dt)
end

function friend:playMod( mod )
  self:stopMod()
  self.bgm = love.audio.newSource(mod, "stream")
  self.bgm:setLooping( true )
  self.bgm:setVolume(0.2)
  love.audio.play(self.bgm)
end

function friend:stopMod()
  if not self.bgm then return end
  love.audio.stop(self.bgm)
  self.bgm = nil
end

