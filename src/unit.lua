
local cpml = require('cpml')
local node2d = require('lib4/node/node2d')
local unit = {}
local mt = {__index = unit}

local global

function unit.new(x, y, type, character, colour)
    if not global then
        global = lib4.root.children.global
    end

    local self = node2d.new()
    setmetatable(self, mt)

    self.position = cpml.vec2(x, y)
    self.pos_last = cpml.vec2(x, y)

    self.type = type or 'unit'

    self.character = character or '@'
    self.colour = colour or {255, 255, 255}

    self.stats = {}
    self.provides = {}
    self.requires = {}

    return self
end

function unit:predraw()
    love.graphics.push()

    love.graphics.translate(self:real_coord())
    love.graphics.setColor(self.colour)
end

function unit:draw()
    love.graphics.print(self.character)
end

function unit:set_pos(x, y)
    self.position = cpml.vec2(x, y)
    self.pos_last = cpml.vec2(x, y)
end

-- returns the units position in chess-like notation, i.e. g3
-- x gets transformed into a string of letters, y stays as a number
function unit:pos()
    local x, y

    if type(self) == 'table' and self.position then
        x = self.position.x
        y = self.position.y
    else
        x = self.x or self[1]
        y = self.y or self[2]
    end
    
    local sign = math.sign(x)
    local x_table = {}
    while x > 0 do
        -- 0x60 is 'a'
        table.insert(x_table, (x % 26) + 0x60)
        x = math.floor(x / 26)
    end
    x = string.char(unpack(x_table))

    if sign == -1 then
        return '-' .. x .. tostring(y)
    else
        return x .. tostring(y)
    end
end

-- returns the real, i.e. the OpenGL coordinates
function unit:real_coord()
    local x, y

    if type(self) == 'table' and self.position then
        x = self.position.x - 1
        y = self.position.y - 1
    else
        x = (self.x or self[1]) - 1
        y = (self.y or self[2]) - 1
    end

    local x_scale = 24
    local y_scale = 24

    x, y = x * x_scale, y * y_scale
    x = x + y * math.cos(math.rad(60)) -- sheer x to the right using ky
                                       -- at 60 deg

    return x, y
end

function unit:dist(other)
    local dx = other.position.x - self.position.x
    local dy = other.position.y - self.position.y

    if math.sign(dx) == math.sign(dy) then
        return math.abs(dx + dy)
    else
        return math.max(abs(dx), abs(dy))
    end
end

function unit:update()
    if self.position ~= self.pos_last then
        local a = unit.pos(self.pos_last)
        local b = self:pos()

        global:move_cell(a, b)
        self.pos_last = cpml.vec2(self.position.x, self.position.y)
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
    __index = node2d,
    __call = function(_, ...) return unit.new(...) end,
})
return unit
