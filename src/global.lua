
local cpml = require('cpml')
local input = require('lib4/inpt')
local node = require('lib4/node')
local file = require('lib4/file')
local cell = require('src/cell')
local unit = require('src/cell/unit')

local global = {}

function global:_load()
    input.add_keycode('global:set_camera_mode', 'q')
    input.add_keycode('global:set_select_mode', 'w')
    input.add_keycode('global:set_move_mode',   'e')
    input.add_keycode('global:set_build_mode',  'r')

    input.add_keycode('global:build_house',      'a')
    input.add_keycode('global:build_farm',       's')
    input.add_keycode('global:build_powerplant', 'd')
    input.add_keycode('global:build_park',       'z')
    input.add_keycode('global:build_townhall',   'x')

    self.font = love.graphics.newFont('assets/fonts/vcr_osd_mono.ttf', 20)
    self.gui_font = love.graphics.newFont()
    love.graphics.setFont(self.font)

    self.mode = 'select' -- camera, select, move, build
    self.building = nil
    self.cursor = cpml.vec2(20, 20)
    self.selected = nil
    self.cell_types = {}
    self.cells = {}

    self.bar = {}
    self.gui = {}

    self:rand()
end

function global:update()
    self.bar = {}
    self.gui = {}

    table.insert(self.bar, {title = 'm', value = self.mode})
    table.insert(self.bar, {value = cell.pos(self.cursor)})

    if self.mode == 'build' and self.building then
        table.insert(self.bar, {title = 'b', value = self.building})
    end
    if self.children[self.selected] then
        table.insert(self.bar, {title = 'sel',
                                value = self.children[self.selected].id})
    end

    if self.mode == 'build' then
        table.insert(self.gui, {value = '(a) House'})
        table.insert(self.gui, {value = '(s) Farm'})
        table.insert(self.gui, {value = '(d) Powerplant'})
        table.insert(self.gui, {value = '(z) Park'})
        table.insert(self.gui, {value = '(x) Townhall'})
    else
        table.insert(self.gui, {title = 'yui  789\nh*k  4*6\nnm,  123'})
    end
end

function global:postdraw()
    love.graphics.push()

    love.graphics.translate(cell.real_coord(self.cursor - cpml.vec2(1/4, 0)))

    love.graphics.setColor(255, 0, 0)
    love.graphics.polygon('line', 0, 0, 12, 24, 24, 0)

    love.graphics.origin()

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 576, 0, 208, 384)
    love.graphics.rectangle('fill', 0, 364, 576, 20)

    love.graphics.setColor(255, 255, 255)
    love.graphics.line(576, 0, 576, 384)
    love.graphics.line(0, 364, 576, 364)

    love.graphics.setFont(self.gui_font)
    local text = ''
    for i, v in ipairs(self.bar) do
        if v.title and v.value then
            text = text .. v.title .. ': ' .. tostring(v.value) .. ' '
        elseif v.title then
            text = text .. v.title .. ' '
        elseif v.value then
            text = text .. tostring(v.value) .. ' '
        else
            text = text .. v.title
        end
    end
    love.graphics.print(text, 8, 364)

    local text = ''
    for i, v in ipairs(self.gui) do
        if v.title and v.value then
            text = text .. v.title .. ': ' .. tostring(v.value) .. '\n'
        elseif v.title then
            text = text .. v.title .. '\n'
        elseif v.value then
            text = text .. tostring(v.value) .. '\n'
        else
            text = text .. v.title .. '\n'
        end
    end
    love.graphics.print(text, 584, 32)

    love.graphics.setFont(self.font)
    love.graphics.pop()
end

function global:rand()
    self.cells = {}
    self.children = {}

    local env = {require('src/cell/coal'), require('src/cell/forest'),
                 require('src/cell/water')}

    for y = 1, 64 do
        for x = 1, 64 do
            if math.random() < 0.1 then
                local cell = env[math.random(1, #env)].new(x, y)
                self:set_cell(cell)
            end
        end
    end

    local adam = unit.new(20, 22)
    local eve = unit.new(22, 20)
    self:set_cell(adam)
    self:set_cell(eve)
end

function global:set_cell(cell)
    local pos = cell:pos()
    self:add(cell, pos)

    if not self.cell_types[cell.type] then
        self.cell_types[cell.type] = 0
    end

    self.cell_types[cell.type] = self.cell_types[cell.type] + 1
    cell.id = cell.type .. '#' .. tostring(self.cell_types[cell.type])
    self.cells[cell.id] = cell
end

function global:move_cell(a, b)
    local cell = self.children[a]

    self:remove(a)
    self:add(cell, b)

    if self.selected == a then
        self.selected = b
        self.cursor = cpml.vec2(cell.position.x, cell.position.y)
    end
end

function global:add(cell, key)
    local id = cell.id
    node.add(self, cell, key)
    cell.id = id
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
    elseif key == 'global:set_build_mode' then
        self.mode = 'build'
    elseif key == 'game:enter' then
        if self.mode == 'select' then 
            self.selected = cell.pos(self.cursor)
        elseif self.mode == 'build' and self.building then
            local building = require('src/cell/' .. self.building)
            local building = building.new(self.cursor.x, self.cursor.y)
            self:set_cell(building)
        end
    end

    if self.mode == 'build' then
        if key == 'global:build_house' then
            self.building = 'house'
        elseif key == 'global:build_farm' then
            self.building = 'farm'
        elseif key == 'global:build_powerplant' then
            self.building = 'powerplant'
        elseif key == 'global:build_park' then
            self.building = 'park'
        elseif key == 'global:build_townhall' then
            self.building = 'townhall'
        end
    end

    if self.mode == 'select'  then
        if key == 'game:left' then
            self.cursor = self.cursor + cpml.vec2(-1, 0)
        elseif key == 'game:right' then
            self.cursor = self.cursor + cpml.vec2(1, 0)
        elseif key == 'game:upl' then
            self.cursor = self.cursor + cpml.vec2(0, -1)
        elseif key == 'game:upr' then
            self.cursor = self.cursor + cpml.vec2(1, -1)
        elseif key == 'game:downl' then
            self.cursor = self.cursor + cpml.vec2(-1, 1)
        elseif key == 'game:downr' then
            self.cursor = self.cursor + cpml.vec2(0, 1)
        end
    end
end

return global
