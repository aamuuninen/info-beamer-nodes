gl.setup(1024, 768)

local json = require"json"

util.auto_loader(_G)

-- prevent bugs due to the json files not being written in time
function secure_json_decode(content)
    local success, returnvalue = pcall(function(content)
        return json.decode(content)
    end, content)
    if success == true then
        return returnvalue
    end
    return nil
end

-- os.execute is removed, need sleep.
function sleep(seconds)
    local now = sys.now()
    while now + seconds >= sys.now() do
        -- wait..
    end
end

-- round numbers so we dont have loads of unnecessary decimals
function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end


util.file_watch("current", function(content)
    sleep(0.5)
    local newcurrent = secure_json_decode(content)
    if newcurrent ~= nil then
        current = newcurrent
    end
end)

util.file_watch("forecast", function(content)
    sleep(0.5)
    local newforecast = secure_json_decode(content)
    if newforecast ~= nil then
        forecast = newforecast
    end
end)

util.file_watch("weather_background.jpg", function(content)
    background = resource.load_image("weather_background.jpg")
end)

background = resource.load_image("weather_background.jpg")

local PI = 3.14159
function calculatefbwritelookup(angleadd)
    -- calculate sin/pos for the shifted rotation of
    -- fbwrite which is used to simulate a border
    if fbwritepostable ~= nil then
        return
    end
    -- go through all angles and precalculate sin/cos
    local angle = 0
    local i = 1
    fbwritepostable = {}
    while angle < 2*PI do
        fbwritepostable[i] = {}
        fbwritepostable[i].x = 1*math.cos(angle)-1*math.sin(angle)
        fbwritepostable[i].y = 1*math.sin(angle)+1*math.cos(angle)
        angle = angle + angleadd
        i = i + 1
    end
end

function fbwrite(font, x, y, str, size, c1, c2, c3, c4)
    -- font border write (write font with nice border)
    -- cycle through 4 directions for font shift for border:
    local i = 1
    local shiftlength = 10
    local angle = 0
    local angleadd = 2*PI*0.1
    shiftlength = shiftlength * (size/200)
    calculatefbwritelookup(angleadd)
    while angle < 2*PI do
        -- write in black, shifted/rotated around a bit
        -- to simulate a border
        -- calculate shift:_
        local xs,ys = fbwritepostable[i].x,fbwritepostable[i].y

        -- draw font twice (once shifted much, then less)
        font:write(x+xs*shiftlength, y+ys*shiftlength, str,
        size, 0, 0, 0, 1)
        font:write(x+xs*shiftlength*0.5, y+ys*shiftlength*0.5, str,
        size, 0, 0, 0, 1)
        i = i + 1
        angle = angle + angleadd
    end
    -- draw final colored font:
    font:write(x, y, str, size, c1, c2, c3, c4)
end

function node.render()
   -- prepare clock for rendering in top right corner
    gl.clear(1,1,1,1)
    background:draw(0,0,WIDTH,HEIGHT)
    local clock = resource.render_child("analogclock")
    clock:draw(780,30,980,230)


    font = resource.load_font("font.ttf")
    local t = getmetatable(font)
    t.fbwrite = fbwrite
    webfont = resource.load_font("silkscreen.ttf")
    -- get numbers ready for output
    current_temp = current.main.temp - 273.15
    current_humid = current.main.humidity
    current_pressure = current.main.pressure
    current_date = current.date
    lasthour_rain = current.rain["1h"]
    url = current.url

    font:fbwrite(100, 100, "Wetter", 100, 1,0,0,1)
    font:fbwrite(100,250, "Temperatur: " .. round(current_temp,2) .. " °C",50,0,1,0,1) 
    font:fbwrite(100,350, "Luftfeuchte: " .. round(current_humid,2) .. " %",50,0,1,0,1) 
    font:fbwrite(100,450, "Luftdruck: " .. round(current_pressure,2) .. " hPa",50,0,1,0,1) 
    font:fbwrite(100,550, "Niederschlag: " .. round(lasthour_rain,2) .. " mm/h",50,0,1,0,1) 
    font:fbwrite(100,680, "Wetterdaten via " .. url ,20,0,1,0,1) 
    font:fbwrite(100,720, "Aktualisiert um " .. current_date ,20,0,1,0,1)
end
