--[[
License : GLPv3, see LICENCE in root of repository

Authors : Nikolay Fiykov, v1
--]]
local lu = require("luaunit")
local tools = require("tools")
local nodemcu = require("nodemcu")
local m = require("main")

function test()
  nodemcu.reset()

  m({oledSCL = 1, oledSDA = 2, relayS = 8, rotarySW = 3, rotaryB = 6, rotaryA = 7, dht22S = 5})

  nodemcu.rotary_turn(0, 22)
  nodemcu.rotary_press(0, rotary.CLICK)
end

os.exit(lu.run())
