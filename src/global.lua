
local cpml = require('cpml')
local input = require('lib4/inpt')
local node = require('lib4/node')
local global = {}

function global:_load()
    input.add_keycode('global:set_camera_mode', 'q')
    input.add_keycode('global:set_select_mode', 'w')
    input.add_keycode('global:set_move_mode',   'e')

    self.font = love.graphics.newFont('vcr_osd_mono.ttf', 12)
    love.graphics.setFont(self.font)

    self.mode = 'camera' -- camera, select, move
    self.selection = cpml.vec2(1, 1)
    self.cell_ids = {}
    self.cells = {}
end

function global:set_cell(cell)
    local pos = cell:pos()
    self:add(cell, pos)

    if not self.cell_ids[cell.id] then
        self.cell_ids[cell.id] = 0
    end

    self.cell_ids[cell.id] = self.cell_ids[cell.id] + 1
    cell.id = cell.id .. '#' .. tostring(self.cell_ids[cell.id])
    self.cells[cell.id] = cell
end

function global:move_cell(a, b)
    local cell = self.children[a]
    self:del(a)
    self:add(cell, b)
end

function global:is_selected(cell)
    if cell.t then
        return self.children[self.selection] == cell
    else
        return self.selection == cell
    end
end


function global:_keypressed(_, _, key)
    if key == 'global:set_camera_mode' then
        self.mode = 'camera'
    elseif key == 'global:set_select_mode' then
        self.mode = 'select'
    elseif key == 'global:set_move_mode' then
        self.mode = 'move'
    end
end

function global:_keydown(_, _, key)
    if self.mode == 'select' then
        if key == 'game:enter' then
        elseif key == 'game:left' then
            self.selection = self.selection + cpml.vec2(-1, 0)
        elseif key == 'game:right' then
            self.selection = self.selection + cpml.vec2(1, 0)
        elseif key == 'game:upl' then
            self.selection = self.selection + cpml.vec2(-1, -1)
        elseif key == 'game:upr' then
            self.selection = self.selection + cpml.vec2(1, -1)
        elseif key == 'game:downl' then
            self.selection = self.selection + cpml.vec2(-1, 1)
        elseif key == 'game:downr' then
            self.selection = self.selection + cpml.vec2(1, 1)
        end
    end
end

return global
