
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
    self.velocity = cpml.vec2()
end

function cam:_update(dt)
    self.position = self.position + self.velocity * dt
    self.velocity = cpml.vec2()
end

function cam:_keydown(_, _, key)
    if global.mode == 'camera' then
        local c = math.cos(math.rad(60))
        local s = math.sin(math.rad(60))
        local speed = 1000
        if key == 'game:enter' then
        elseif key == 'game:left' then
            self.velocity = cpml.vec2(-1*speed, 0*speed)
        elseif key == 'game:right' then
            self.velocity = cpml.vec2(1*speed, 0*speed)
        elseif key == 'game:upl' then
            self.velocity = cpml.vec2(-c*speed, -s*speed)
        elseif key == 'game:upr' then
            self.velocity = cpml.vec2(c*speed, -s*speed)
        elseif key == 'game:downl' then
            self.velocity = cpml.vec2(-c*speed, s*speed)
        elseif key == 'game:downr' then
            self.velocity = cpml.vec2(c*speed, s*speed)
        elseif key == 'game:up' then
            self.velocity = cpml.vec2(0*speed, -1*speed)
        elseif key == 'game:down' then
            self.velocity = cpml.vec2(0*speed, 1*speed)
        end
    end
end

return cam
