
local cpml = require('cpml')
local cell = require('src/cell')
local powerplant = {}
local mt = {__index = powerplant}
powerplant.build = {material = 5, on = {grass = true, forest = true}}

local global

function powerplant.new(x, y)
    if not global then
        global = lib4.root.children.global
    end

    local self = cell.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)

    self.type = 'powerplant'

    self.character = 'e'
    self.colour = {51, 100, 135}

    self.radius = 5
    self.stats = {human = 0, fuel = 2}
    self.provides = {energy = 4}
    self.requires = {human = 1, fuel = 1}
    self.takes = {unit = {rest = 1, entertainment = 1, health = 1}}

    return self
end

setmetatable(powerplant, {
    __index = cell,
    __call = function(_, ...) return powerplant.new(...) end,
})
return powerplant
