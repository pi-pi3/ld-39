
local cpml = require('cpml')
local cell = require('src/cell')
local coal = {}
local mt = {__index = coal}
coal.build = false

local global

function coal.new(x, y)
    if not global then
        global = lib4.root.children.global
    end

    local self = cell.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)

    self.type = 'coal'

    self.character = 'c'
    self.colour = {49, 49, 71}

    self.radius = 5
    self.stats = {material = 5}
    self.provides = {}
    self.requires = {}

    return self
end

setmetatable(coal, {
    __index = cell,
    __call = function(_, ...) return coal.new(...) end,
})
return coal
