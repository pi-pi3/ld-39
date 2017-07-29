
local cpml = require('cpml')
local input = require('lib4/inpt')
local node = require('lib4/node')
local file = require('lib4/file')
local unit = file.load_src('src://unit.lua')()

local global = {}

function global:_load()
    input.add_keycode('global:set_camera_mode', 'q')
    input.add_keycode('global:set_select_mode', 'w')
    input.add_keycode('global:set_move_mode',   'e')

    self.font = love.graphics.newFont('assets/fonts/vcr_osd_mono.ttf', 20)
    love.graphics.setFont(self.font)

    self.mode = 'camera' -- camera, select, move
    self.selection = cpml.vec2(1, 1)
    self.selected = nil
    self.unit_types = {}
    self.units = {}

    --self:set_cell(unit)
    self:rand()
end

function global:draw()
    love.graphics.push()

    love.graphics.translate(unit.real_coord(self.selection - cpml.vec2(1/4, 0)))

    love.graphics.setColor(255, 0, 0)
    love.graphics.polygon('line', 0, 0, 12, 24, 24, 0)

    love.graphics.pop()
end

function global:rand()
    self.units = {}
    self.children = {}

    for y = 1, 1 do
        for x = 1, 1 do
            local u = unit.new(x, y)
            self:set_cell(u)
        end
    end
end

function global:set_cell(cell)
    local pos = cell:pos()
    self:add(cell, pos)

    if not self.unit_types[cell.type] then
        self.unit_types[cell.type] = 0
    end

    self.unit_types[cell.type] = self.unit_types[cell.type] + 1
    cell.id = cell.type .. '#' .. tostring(self.unit_types[cell.type])
    self.units[cell.id] = cell
end

function global:move_cell(a, b)
    local cell = self.children[a]
    self:remove(a)
    self:add(cell, b)
    if self.selected == a then
        self.selected = b
        self.selection = cpml.vec2(cell.position.x, cell.position.y)
    end
end

function global:is_selected(cell)
    if type(cell) == 'table'  and cell.t then
        return self.selected == cell:pos()
    elseif type(cell) == 'string' then
        return self.selected == cell
    end
end


function global:_keypressed(_, _, key)
    if key == 'global:set_camera_mode' then
        self.mode = 'camera'
    elseif key == 'global:set_select_mode' then
        self.mode = 'select'
    elseif key == 'global:set_move_mode' then
        self.mode = 'move'
    elseif self.mode == 'select' and key == 'game:enter' then
        self.selected = unit.pos(self.selection)
    end

    if self.mode == 'move'  then
        if key == 'game:left' then
            self.selection = self.selection + cpml.vec2(-1, 0)
        elseif key == 'game:right' then
            self.selection = self.selection + cpml.vec2(1, 0)
        elseif key == 'game:upl' then
            self.selection = self.selection + cpml.vec2(0, -1)
        elseif key == 'game:upr' then
            self.selection = self.selection + cpml.vec2(1, -1)
        elseif key == 'game:downl' then
            self.selection = self.selection + cpml.vec2(-1, 1)
        elseif key == 'game:downr' then
            self.selection = self.selection + cpml.vec2(0, 1)
        end
    end
end

return global
