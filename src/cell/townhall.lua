
local cpml = require('cpml')
local cell = require('src/cell')
local townhall = {}
local mt = {__index = townhall}

local global

function townhall.new(x, y)
    if not global then
        global = lib4.root.children.global
    end

    local self = cell.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)

    self.type = 'townhall'

    self.character = 'T'
    self.colour = {128, 63, 21}

    self.radius = 5
    self.stats = {human = 0, energy = 3}
    self.provides = {peace = 10}
    self.requires = {human = 3, energy = 3}

    return self
end

setmetatable(townhall, {
    __index = cell,
    __call = function(_, ...) return townhall.new(...) end,
})
return townhall
