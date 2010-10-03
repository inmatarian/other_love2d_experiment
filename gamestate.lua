
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

