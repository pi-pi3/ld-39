
local cpml = require('cpml')
local cell = require('src/cell')
local forest = {}
local mt = {__index = forest}
forest.build = false

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
    self.stats = {food = 5, material = 1}
    self.provides = {oxygen = 3}
    self.requires = {}

    return self
end

setmetatable(forest, {
    __index = cell,
    __call = function(_, ...) return forest.new(...) end,
})
return forest
