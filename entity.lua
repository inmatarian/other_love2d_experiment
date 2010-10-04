
require "object"

module(..., package.seeall)

local entity = object:subclass( getfenv() )

function entity:init()
  self:superinit( entity )

  self.x = 0
  self.y = 0
  self.w = 0
  self.h = 0

  self.solid = true

  self.velocity = { x = 0, y = 0 }
  self.maxvelocity = { x = 0, y = 0 }
  self.acceleration = { x = 0, y = 0 }
  self.drag = { x = 0, y = 0 }
  self.oldpos = { x = 0, y = 0 }
end

function entity:draw()
  --
end

function entity:update( dt )
  self:saveOldPosition()
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

function entity:saveOldPosition()
  self.oldpos.x = self.x
  self.oldpos.y = self.y
end

function entity:overlaps( other )
  local max, min = math.max, math.min
  local l1, r1, u1, d1 = self.x, self.x + self.w, self.y, self.y + self.h
  local l2, r2, u2, d2 = other.x, other.x + other.w, other.y, other.y + other.h
  return ( max(l1, l2) <= min(r1, r2) and max(u1, u2) <= min(d1, d2) )
end

