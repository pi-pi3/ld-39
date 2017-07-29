
local cpml = require('cpml')
local cell = require('src/cell')
local park = {}
local mt = {__index = park}
park.build = {material = 5, on = {grass = true, forest = true}}

local global

function park.new(x, y)
    if not global then
        global = lib4.root.children.global
    end

    local self = cell.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)

    self.type = 'park'

    self.character = 'P'
    self.colour = {104, 183, 62}

    self.radius = 5
    self.stats = {energy = 1}
    self.provides = {rest = 1, entertainment = 3}
    self.requires = {energy = 1}

    return self
end

setmetatable(park, {
    __index = cell,
    __call = function(_, ...) return park.new(...) end,
})
return park
