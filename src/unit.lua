
local cpml = require('cpml')
local unit = {}

local global

function unit:_load()
    global = lib4.root.children.global

    self.type = 'unit'

    self.pos_last = cpml.vec2(1)
    self.position.x = 1
    self.position.y = 1

    self.colour = {255, 255, 255} -- the british have taken over the world!
end

function unit:predraw()
    love.graphics.push()

    love.graphics.translate(self:real_coord())
    love.graphics.setColor(self.colour)
end

function unit:draw()
    love.graphics.print(self.character)
end

-- returns the units position in chess-like notation, i.e. g3
-- x gets transformed into a string of letters, y stays as a number
function unit:pos()
    local x, y

    if self.position then
        x = self.position.x
        y = self.position.y
    else
        x = self.x or self[1]
        y = self.y or self[2]
    end
    
    local x_table = {}
    while x > 0 do
        -- 0x61 is 'a'
        table.insert(x_table, (x % 26) + 0x61)
        x = math.floor(x / 26)
    end
    x = string.char(unpack(x_table))

    return x .. tostring(y)
end

-- returns the real, i.e. the OpenGL coordinates
function unit:real_coord()
    local x, y

    if self.position then
        x = self.position.x
        y = self.position.y
    else
        x = self.x or self[1]
        y = self.y or self[2]
    end

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

function unit:_update()
    if self.position ~= self.pos_last then
        local a = unit.pos(self.pos_last)
        local b = self:pos()

        global:move_cell(a, b)
        self.pos_last = self.position
    end
end

function unit:_keydown(_, _, key)
    if global.mode == 'move' and global.is_selected(self) then
        if key == 'game:enter' then
        elseif key == 'game:left' then
            self.position = self.position + cpml.vec2(-1, 0)
        elseif key == 'game:right' then
            self.position = self.position + cpml.vec2(1, 0)
        elseif key == 'game:upl' then
            self.position = self.position + cpml.vec2(-1, -1)
        elseif key == 'game:upr' then
            self.position = self.position + cpml.vec2(1, -1)
        elseif key == 'game:downl' then
            self.position = self.position + cpml.vec2(-1, 1)
        elseif key == 'game:downr' then
            self.position = self.position + cpml.vec2(1, 1)
        end
    end
end

return unit
