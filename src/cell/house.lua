
local cpml = require('cpml')
local cell = require('src/cell')
local house = {}
local mt = {__index = house}

local global

function house.new(x, y)
    if not global then
        global = lib4.root.children.global
    end

    local self = cell.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)

    self.type = 'house'

    self.character = 'H'
    self.colour = {128, 63, 21}

    self.radius = 5
    self.stats = {energy = 1}
    self.provides = {rest = 3, entertainment = 1, health = 1}
    self.requires = {energy = 1}

    return self
end

setmetatable(house, {
    __index = cell,
    __call = function(_, ...) return house.new(...) end,
})
return house