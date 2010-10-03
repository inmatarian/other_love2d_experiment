
require "object"

module(..., package.seeall)

local entity = object:subclass( getfenv() )

function entity:init()
  self:superinit( entity )

  self.x = 0
  self.y = 0
  self.w = 0
  self.h = 0

  self.velocity = { x = 0, y = 0 }
  self.maxvelocity = { x = 0, y = 0 }
  self.acceleration = { x = 0, y = 0 }
  self.drag = { x = 0, y = 0 }
  self.hull = { x = 0, y = 0, w = 0, h = 0 }
end

function entity:draw()
  --
end

function entity:update( dt )
  self:prepareCollisionHull()
  self:move( dt )
end

local function sign( x )
  if x < 0 then return -1 elseif x > 0 then return 1 else return 0 end
end

local function getDelta( vel, acc, drag, dt )
  if acc ~= 0 then return acc * dt end
  if drag > 0 then
    local delta = drag * dt
    local absvel = math.abs( vel )
    if absvel < delta then
      delta = sign(vel) * absvel
    end
    return delta
  end
  return 0
end

function entity:move( dt )
  local vx, vy = self.velocity.x, self.velocity.y
  vx = vx + getDelta( vx, self.acceleration.x, self.drag.x, dt )
  vy = vy + getDelta( vy, self.acceleration.y, self.drag.y, dt )

  if math.abs( vx ) > self.maxvelocity.x then
    vx = sign( vx ) * self.maxvelocity.x
  end

  if math.abs( vy ) > self.maxvelocity.y then
    vy = sign( vy ) * self.maxvelocity.y
  end

  self.x = self.x + ( vx * dt )
  self.y = self.y + ( vy * dt )

  self.velocity.x = vx
  self.velocity.y = vy
end

function entity:prepareCollisionHull()
  self.hull.x = self.x
  self.hull.y = self.y
  self.hull.w = self.w
  self.hull.h = self.h
end

function entity:testCollision( other )


end

