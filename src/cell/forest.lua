
local cpml = require('cpml')
local cell = require('src/cell')
local forest = {}
local mt = {__index = forest}

local global

function forest.new(x, y)
    if not global then
        global = lib4.root.children.global
    end

    local self = cell.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)

    self.type = 'forest'

    self.character = 'f'
    self.colour = {71, 144, 48}

    self.radius = 5
    self.stats = {human = 0}
    self.provides = {food = 2, oxygen = 3, fuel = 1, material = 1}
    self.requires = {human = 2}

    return self
end

setmetatable(forest, {
    __index = cell,
    __call = function(_, ...) return forest.new(...) end,
})
return forest
