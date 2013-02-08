gl.setup(1920, 1080)

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

function node.render()
   -- prepare clock for rendering in top right corner
    gl.clear(0,0.02,0.2,1)
   
    local clock = resource.render_child("analogclock")
    clock:draw(1630,20,1900,290)


    font = resource.load_font("font.ttf")
    -- get numbers ready for output
    current_temp = current.main.temp - 273.15
    current_humid = current.main.humidity
    current_pressure = current.main.pressure
    lasthour_rain = current.rain["1h"]
    url = current.url

    font:write(120, 200, "Das Aktuelle Wetterstudio", 100, 1,1,1,1)
    font:write(120,400, "Die aktuelle Temperatur beträgt " .. round(current_temp,2) .. " °C",50,1,1,1,1) 
    font:write(120,500, "Die aktuelle Luftfeuchte beträgt " .. round(current_humid,2) .. " %",50,1,1,1,1) 
    font:write(120,600, "Der aktuelle Luftdruck beträgt " .. round(current_pressure,2) .. " hPa",50,1,1,1,1) 
    font:write(120,700, "In der letzten Stunde hat es " .. round(lasthour_rain,2) .. " mm geregnet",50,1,1,1,1) 
    font:write(120,1000, "Wetterdaten via " .. url ,20,1,1,1,1) 
end
