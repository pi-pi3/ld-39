
local cpml = require('cpml')
local cell = require('src/cell')
local unit = {}
local mt = {__index = unit}

local global

function unit.new(x, y)
    if not global then
        global = lib4.root.children.global
    end

    local self = cell.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)
    self.pos_last = cpml.vec2(x, y)

    self.type = 'unit'

    self.character = '@'
    self.colour = {255, 255, 255}

    self.radius = 2
    self.stats = {health = 7, oxygen = 7, water = 7,
                  food = 7, rest = 7, entertainment = 7}
    self.provides = {human = 1} -- radial units end with _r
                                -- integers end with _i
    self.requires = {health = 1, oxygen = 1, water = 1,
                     food = 1, rest = 1, entertainment = 1}

    return self
end

function unit:update()
    cell.update(self)

    if self.position ~= self.pos_last then
        local a = unit.pos(self.pos_last)
        local b = self:pos()

        if global:move_cell(a, b) then
            self.pos_last = cpml.vec2(self.position.x, self.position.y)
        else
            self.position = cpml.vec2(self.pos_last.x, self.pos_last.y)
        end
    end
end

function unit:keypressed(_, _, key)
    if global.mode == 'move' and global:is_selected(self) then
        if key == 'game:enter' then
        elseif key == 'game:left' then
            self.position = self.position + cpml.vec2(-1, 0)
        elseif key == 'game:right' then                      
            self.position = self.position + cpml.vec2(1, 0)
        elseif key == 'game:upl' then                        
            self.position = self.position + cpml.vec2(0, -1)
        elseif key == 'game:upr' then                        
            self.position = self.position + cpml.vec2(1, -1)
        elseif key == 'game:downl' then                      
            self.position = self.position + cpml.vec2(-1, 1)
        elseif key == 'game:downr' then                      
            self.position = self.position + cpml.vec2(0, 1)
        end
    end
end

setmetatable(unit, {
    __index = cell,
    __call = function(_, ...) return unit.new(...) end,
})
return unit
