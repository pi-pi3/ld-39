
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
    self.requires = {oxygen = 1, water = 1, food = 1}

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
    if not global:is_selected(self) then return end
    if global.mode == 'move' then
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

    if global.mode == 'destroy' then
        if key == 'game:enter' then
            local pos = cell.pos(global.cursor)
            local cell = global.children[pos]
            if cell == self then
                return
            end
            global:remove(pos)
            for k, v in pairs(cell.stats) do
                if global.stats[k] then
                    global.stats[k] = global.stats[k] + v
                elseif self.stats[k] then
                    self.stats[k] = self.stats[k] + v
                end
            end
        end
    end
end

setmetatable(unit, {
    __index = cell,
    __call = function(_, ...) return unit.new(...) end,
})
return unit
