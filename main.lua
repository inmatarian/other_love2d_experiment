-- MAIN.LUA

math.randomseed( os.time() )

require "object"
require "friend"
require "gamestate"
require "entity"

----------------------------------------
local scr_w = love.graphics.getWidth()
local scr_h = love.graphics.getHeight()

local scr_bounds = {
  l = scr_w / 3;
  r = scr_w * 2 / 3;
  u = scr_h / 3;
  d = scr_h * 2 / 3
}

----------------------------------------

TestEnt = entity:subclass()

function TestEnt:init()
  self:superinit( TestEnt )
  
  self.x = scr_w / 2
  self.y = scr_h / 2
  self.w = 8
  self.h = 8

  self.maxvelocity.x = 96
  self.maxvelocity.y = 96
  self:pingpong( -1 + math.random() * 2, -1 + math.random() * 2 )

  self:randomizeColor()
  self.color.a = 0
  self.solid = false
end

function TestEnt:randomizeColor()
  local A = 255
  local C = 255
  local hue = math.random() * 6.0
  local X = 255 * (1 - math.abs( (hue % 2) - 1 ))
  
  if hue < 1.0 then     self.color = { r=C, g=X, b=0, a=A }
  elseif hue < 2.0 then self.color = { r=X, g=C, b=0, a=A }
  elseif hue < 3.0 then self.color = { r=0, g=C, b=X, a=A }
  elseif hue < 4.0 then self.color = { r=0, g=X, b=C, a=A }
  elseif hue < 5.0 then self.color = { r=X, g=0, b=C, a=A }
  else                  self.color = { r=C, g=0, b=X, a=A }
  end

end

function TestEnt:draw()
  local c = self.color
  love.graphics.setColor( c.r, c.b, c.g, c.a )
  love.graphics.rectangle( "fill", self.x, self.y, self.w, self.h )
end

function TestEnt:pingpong( accx, accy )
  if accx then self.acceleration.x = accx * 48 * (0.75 + math.random()/4) end
  if accy then self.acceleration.y = accy * 48 * (0.75 + math.random()/4) end
end

function TestEnt:update(dt)
  entity.update( self, dt )
  if self.color.a < 255 then
    self.color.a = self.color.a + 32 * dt
    if self.color.a >= 255 then self.color.a = 255; self.solid = true end
  end
  local b = scr_bounds
  if self.x < b.l then self:pingpong( 1, false ) end
  if self.x > b.r then self:pingpong( -1, false ) end
  if self.y < b.u then self:pingpong( false, 1 ) end
  if self.y > b.d then self:pingpong( false, -1 ) end
end

----------------------------------------

TestState = gamestate:subclass()
function TestState:init()
  self:superinit( TestState )
  self.clock = 0
  self.target = 0
  self.count = 0
end

function TestState:update(dt)
  self.clock = self.clock + dt
  if self.clock > self.target then
    self.target = self.target + 1
    if self.count < 100 then
      self:addEntity( TestEnt:new() )
      self.count = self.count + 1
    end
    self.fps = string.format("%.2f", love.timer.getFPS())
  end

  gamestate.update( self, dt )
end

function TestState:draw()
  gamestate.draw( self )

  love.graphics.setColor( 255, 255, 255 )
  love.graphics.print('FPS: '..self.fps, 10, 20)
  love.graphics.print('Count: '..self.count, 10, 40)
end

----------------------------------------

Tester = friend:subclass()

function Tester:init()
  self:superinit( Tester )
  self.state = TestState:new()
end

tester = Tester:new()

