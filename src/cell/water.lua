
local cpml = require('cpml')
local cell = require('src/cell')
local water = {}
local mt = {__index = water}

local global

function water.new(x, y)
    if not global then
        global = lib4.root.children.global
    end

    local self = cell.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)

    self.type = 'water'

    self.character = 'w'
    self.colour = {95, 124, 198}

    self.radius = 5
    self.stats = {}
    self.provides = {food = 1, water = 4}
    self.requires = {}

    return self
end

setmetatable(water, {
    __index = cell,
    __call = function(_, ...) return water.new(...) end,
})
return water
