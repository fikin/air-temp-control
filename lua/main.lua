--[[
License : GLPv3, see LICENCE in root of repository

Authors : Nikolay Fiykov, v1
--]]
local function startTempControl(pinouts, disp, targetTemp)
  local maxTemp = 0
  local minTemp = 0
  local function check(timer)
    disp:clearBuffer()
    disp:setFont(u8g2.font_helvB24_tf)
    status, temp, humi, temp_dec, humi_dec = dht.read(pinouts.dht22S)
    if status == dht.OK then
      maxTemp = math.max(maxTemp, temp)
      minTemp = math.min(minTemp, temp)
      disp:clearBuffer()
      disp:drawStr(5, 25, string.format("%dC", math.floor(temp)))
      disp:drawStr(5, 60, string.format("%d%%", math.floor(humi)))
      disp:setFont(u8g2.font_6x10_tf)
      disp:drawStr(80, 15, string.format("Tgt %d", targetTemp))
      disp:drawStr(80, 25, string.format("Max %d", maxTemp))
      disp:drawStr(80, 35, string.format("Min %d", minTemp))
      if math.floor(temp) < targetTemp then
        gpio.write(pinouts.relayS, gpio.HIGH)
        disp:drawStr(80, 60, "...")
      else
        gpio.write(pinouts.relayS, gpio.LOW)
      end
    elseif status == dht.ERROR_CHECKSUM then
      disp:drawStr(30, 25, "DHT")
      disp:drawStr(25, 60, "Error")
    elseif status == dht.ERROR_TIMEOUT then
      disp:drawStr(30, 25, "DHT")
      disp:drawStr(0, 60, "Timeout")
    end
    disp:sendBuffer()
  end
  t = tmr.create()
  t:register(1000, tmr.ALARM_AUTO, check)
  t:start()
  check()
end

local function initOLED(pinouts)
  i2c.setup(0, pinouts.oledSDA, pinouts.oledSCL, i2c.SLOW)
  disp = u8g2.ssd1306_i2c_128x64_noname(0, 0x3c)
  disp:setFlipMode(1)
  disp:setContrast(255)
  disp:setFontMode(0)
  disp:setDrawColor(1)
  disp:setBitmapMode(0)
  disp:setFont(u8g2.font_6x10_tf)
  return disp
end

local function setTargetTemp(pinouts, disp)
  local pos = 0
  local temp = 21
  local function adjustTargetTemp(type, pos1, when)
    temp = temp + (pos < pos1 and -1 or 1)
    pos = pos1
    disp:clearBuffer()
    disp:setFont(u8g2.font_helvB24_tf)
    disp:drawStr(20, 40, string.format("> %d C", temp))
    disp:sendBuffer()
  end
  rotary.on(
    0,
    rotary.CLICK,
    function(type, pos1, when)
      rotary.close(0)
      startTempControl(pinouts, disp, temp)
    end
  )
  rotary.on(0, rotary.TURN, adjustTargetTemp)
  adjustTargetTemp(0, 0, 0)
end

return function(pinouts)
  gpio.mode(pinouts.relayS, gpio.OUTPUT)
  gpio.write(pinouts.relayS, gpio.LOW)
  rotary.setup(0, pinouts.rotaryA, pinouts.rotaryB, pinouts.rotarySW)
  disp = initOLED(pinouts)
  setTargetTemp(pinouts, disp)
end
