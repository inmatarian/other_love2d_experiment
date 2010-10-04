
require "object"
require "entity"

module(..., package.seeall)

local gamestate = object:subclass( getfenv() )

function gamestate:init()
  self:superinit( gamestate )

  self.entities = {}
  self.reverse_entities = {}
end

function gamestate:update( dt )
  local ent
  for _, ent in ipairs( self.entities ) do
    ent:update(dt)
  end

  self:detectCollisions()
end

function gamestate:detectCollisions()
  -- shitty collision detection
  local i, j
  local N = #self.entities
  for i = 1, N - 1 do
    local ent1 = self.entities[i]
    if ent1.solid then
      for j = i + 1, N do
        local ent2 = self.entities[j]
        if ent2.solid and ent1:overlaps(ent2) then
          ent1.velocity.x, ent2.velocity.x = ent2.velocity.x, ent1.velocity.x
          ent1.velocity.y, ent2.velocity.y = ent2.velocity.y, ent1.velocity.y
          ent1.x, ent1.y = ent1.oldpos.x, ent1.oldpos.y
          ent2.x, ent2.y = ent2.oldpos.x, ent2.oldpos.y
        end
      end
    end
  end
end

function gamestate:draw()
  local ent
  for _, ent in ipairs( self.entities ) do
    ent:draw()
  end
end

function gamestate:addEntity( ent )
  self:insertEntity( #self.entities + 1, ent )
end

function gamestate:insertEntity( pos, ent )
  local oldpos = self.reverse_entities[ ent ]
  if type( oldpos ) == "number" then
    -- check if inserting at same location
    if oldpos == pos then return end
    -- remove from list
    self:removeEntity( ent )
    -- adjust, since the list size changed
    if pos > oldpos then pos = pos - 1 end
  end
  table.insert( self.entities, pos, ent )
  self.entities[ pos ] = ent
  self.reverse_entities[ ent ] = pos
end

function gamestate:removeEntity( ent )
  if type( self.reverse_entities[ ent ] ) ~= "number" then return end
  table.remove( self.entities, self.reverse_entites[ent] )
end

