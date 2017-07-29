
local cpml = require('cpml')
local node2d = require('lib4/node/node2d')
local cell = {}
local mt = {__index = cell}

local global

function cell:update()
    if not global then
        global = lib4.root.children.global
    end

    if global:is_selected(self) then
        if DEBUG then
            table.insert(global.gui, {title = self.character, value = self:name()})
        else
            table.insert(global.gui, {title = self.character})
        end

        table.insert(global.gui, {title = 'Radius', self.radius})

        table.insert(global.gui, {title = 'Stats'})
        for k, v in pairs(self.stats) do
            table.insert(global.gui, {title = ' ' .. k, value = tostring(v)})
        end

        table.insert(global.gui, {title = 'Requires'})
        for k, v in pairs(self.requires) do
            table.insert(global.gui, {title = ' ' .. k, value = tostring(v)})
        end

        table.insert(global.gui, {title = 'Provides'})
        for k, v in pairs(self.provides) do
            table.insert(global.gui, {title = ' ' .. k, value = tostring(v)})
        end

        if self.takes then
            table.insert(global.gui, {title = 'Takes'})
            for k, v in pairs(self.takes) do
                table.insert(global.gui, {title = ' ' .. k, value = tostring(v)})
            end
        end
    end
end

function cell:predraw()
    love.graphics.push()

    love.graphics.translate(self:real_coord())
    love.graphics.setColor(self.colour)
end

function cell:draw()
    love.graphics.print(self.character)
end

function cell:set_pos(x, y)
    self.position = cpml.vec2(x, y)
    self.pos_last = cpml.vec2(x, y)
end

-- returns the cells position in chess-like notation, i.e. g3
-- x gets transformed into a string of letters, y stays as a number
function cell:pos()
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
function cell:real_coord()
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

function cell:dist(other)
    local dx = other.position.x - self.position.x
    local dy = other.position.y - self.position.y

    if math.sign(dx) == math.sign(dy) then
        return math.abs(dx + dy)
    else
        return math.max(math.abs(dx), math.abs(dy))
    end
end

function cell:good_eh()
    for k, v in pairs(self.stats) do
        if self.stats[k] <= 0 then
            return false
        end
    end

    return true
end

function cell:tick()
    if self:good_eh() then
        local resources = table.copy(self.provides)
        for _, other in pairs(global.children) do
            if self:dist(other) <= self.radius then
                for k, r in pairs(other.requires) do
                    local resource = resources[k] 
                    local needed = r - other.stats[k]
                    if resource and needed > 0 then 
                        local used = math.min(resource, needed)

                        other.stats[k] = other.stats[k] + used
                        resources[k] = resources[k] - used

                        if other.takes and other.takes[self.type] then
                            local takes = other.takes[self.type]
                            for k, other in pairs(takes) do
                                self.stats[k] = math.max(self.stats[k] - other,
                                                         0)
                            end
                        end
                    end
                end
            end
        end
    end

    for k, v in pairs(self.requires) do
        self.stats[k] = math.max(self.stats[k] - v, 0)
    end
end

setmetatable(cell, {
    __index = node2d,
    __call = function(_, ...) return cell.new(...) end,
})
return cell
