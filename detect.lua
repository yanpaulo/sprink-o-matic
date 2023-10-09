local trigger_pin=2
gpio.mode(trigger_pin, gpio.OUTPUT)

local detect_pin=5
gpio.mode(detect_pin, gpio.INT)

local default_detected_event = function(distance_cm)
    print("Detected distance: " ..distance_cm.. "cm")
end

local detected_event = default_detected_event
local detect_start_time = nil

local detect_both = function(level, when)
    if(level == gpio.HIGH) then
        detect_start_time = when
    else
        local detect_end_time = when - (detect_start_time or when)
        local detect_distance = (detect_end_time * 340 * 100 ) / (2 * 1000 * 1000)
        detected_event(detect_distance)
    end
end

gpio.trig(detect_pin, "none")
gpio.trig(detect_pin, "both", detect_both)

detect = function(callback)
    gpio.write(trigger_pin, gpio.LOW);
    tmr.delay(5);
    gpio.write(trigger_pin, gpio.HIGH);
    tmr.delay(10);
    gpio.write(trigger_pin, gpio.LOW);
    
    detected_event = callback or default_detected_event
end

