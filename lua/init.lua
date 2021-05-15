--[[
License : GLPv3, see LICENCE in root of repository

Authors : Nikolay Fiykov, v1
--]]
local function startup()
  require("main")({oledSCL = 1, oledSDA = 2, relayS = 8, rotarySW = 3, rotaryB = 6, rotaryA = 7, dht22S = 5})
end

print("1 sec to start ...")
local t = tmr.create()
t:register(1000, tmr.ALARM_SINGLE, startup)
t:start()
