dofile("detect.lua")
dofile("spray.lua")

local detect_timer = tmr.create()

detect_event = function(distance_cm)
    if(distance_cm < 150) then
        detect_timer:stop()
        print("D: " ..distance_cm.. "cm")
        spray()
        detect_timer:start(true)
    end
end

loop_event = function()
    detect(detect_event)
end

detect_timer:register(500, tmr.ALARM_AUTO, loop_event)
detect_timer:start(true)
