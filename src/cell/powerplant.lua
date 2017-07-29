
local cpml = require('cpml')
local cell = require('src/cell')
local powerplant = {}
local mt = {__index = powerplant}

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
    self.stats = {human = 2}
    self.provides = {energy = 4}
    self.requires = {human = 2}

    return self
end

setmetatable(powerplant, {
    __index = cell,
    __call = function(_, ...) return powerplant.new(...) end,
})
return powerplant
