
local cpml = require('cpml')
local input = require('lib4/inpt')
local cam = {}

local global

function cam:_load()
    global = self.children.global

    love.keyboard.setKeyRepeat(false)
    input.enable_keyevents()

    -- j-based, KP5-based
    input.add_keycode('game:enter', 'j', 'kp5', 'enter')
    input.add_keycode('game:left',  'h', 'kp4', 'left')
    input.add_keycode('game:right', 'k', 'kp6', 'right')
    input.add_keycode('game:upl',   'y', 'kp7')
    input.add_keycode('game:upr',   'i', 'kp9')
    input.add_keycode('game:downl', 'n', 'kp1')
    input.add_keycode('game:downr', ',', 'kp3')
    input.add_keycode('game:up',    'u', 'kp8', 'up')
    input.add_keycode('game:down',  'm', 'kp2', 'down')

    self.position = cpml.vec2(768, 512)
end

function cam:_keydown(_, _, key)
    if global.mode == 'camera' then
        local c = math.cos(math.rad(60))
        local s = math.sin(math.rad(60))
        if key == 'game:enter' then
        elseif key == 'game:left' then
            self.position = self.position + cpml.vec2(-1, 0)
        elseif key == 'game:right' then
            self.position = self.position + cpml.vec2(1, 0)
        elseif key == 'game:upl' then
            self.position = self.position + cpml.vec2(-c, -s)
        elseif key == 'game:upr' then
            self.position = self.position + cpml.vec2(c, -s)
        elseif key == 'game:downl' then
            self.position = self.position + cpml.vec2(-c, s)
        elseif key == 'game:downr' then
            self.position = self.position + cpml.vec2(c, s)
        elseif key == 'game:up' then
            self.position = self.position + cpml.vec2(0, -1)
        elseif key == 'game:down' then
            self.position = self.position + cpml.vec2(0, 1)
        end
    end
end

return cam
