
local cpml = require('cpml')
local cell = require('src/cell')
local farm = {}
local mt = {__index = farm}
farm.build = {material = 4, on = {grass = true, forest = true}}

local global

function farm.new(x, y)
    if not global then
        global = lib4.root.children.global
    end

    local self = cell.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)

    self.type = 'farm'

    self.character = 'F'
    self.colour = {213, 89, 176}

    self.radius = 5
    self.stats = {human = 0, energy = 1}
    self.provides = {food = 4}
    self.requires = {human = 2, energy = 1}

    return self
end

setmetatable(farm, {
    __index = cell,
    __call = function(_, ...) return farm.new(...) end,
})
return farm
