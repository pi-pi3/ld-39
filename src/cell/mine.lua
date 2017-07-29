
local cpml = require('cpml')
local cell = require('src/cell')
local mine = {}
local mt = {__index = mine}
mine.build = {material = 2, on = {coal = true}}

local global

function mine.new(x, y)
    if not global then
        global = lib4.root.children.global
    end

    local self = cell.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)

    self.type = 'mine'

    self.character = 'm'
    self.colour = {87, 43, 21}

    self.radius = 5
    self.stats = {human = 0}
    self.provides = {fuel = 3}
    self.requires = {human = 1}
    self.takes = {unit = {rest = 2, entertainment = 2, health = 2}}

    return self
end

setmetatable(mine, {
    __index = cell,
    __call = function(_, ...) return mine.new(...) end,
})
return mine
