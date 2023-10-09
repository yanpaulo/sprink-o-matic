local pwm_pin = 1
local spray_cycle_count = 10
local spray_cycle = 0
local spray_state = -1
local spray_timer = tmr.create()
local running = false

local spray_event = function()
    print("Cycle:" .. spray_cycle)
    print("State:" .. spray_state)
    spray_state = spray_state * -1
    pwm2.set_duty(pwm_pin, 3 + spray_state)
    if spray_cycle > spray_cycle_count then
        spray_timer:stop()
        pwm2.set_duty(pwm_pin, 2)
        pwm2.stop()
        spray_cycle = 0
        running = false
    end
    spray_cycle = spray_cycle + 1
    
end

pwm2.stop()

spray_timer:unregister()
spray_timer:register(700, tmr.ALARM_AUTO, spray_event)

spray = function()
    print("Spray requested")
    if(running == false) then
        spray_state = -1
        spray_cycle = 1
        running = true
        pwm2.setup_pin_hz(pwm_pin,50,40,2) -- pin 1, PWM freq of 50hz, 40 steps (0.5ms), initial duty 2 period step  (1ms)
        pwm2.start()
        spray_timer:start(true)
    end
end