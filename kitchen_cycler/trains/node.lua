gl.setup(1024, 768)

local dom = require "slaxdom"

util.auto_loader(_G)

font = resource.load_font("font.ttf")

function kid(node, name, number, debug)
    if number == nil then number = 1 end
    local orignumber = number
    for i,n in ipairs(node.kids) do
         if n.name ~= nil then
             if debug then print("comparing " .. n.name .. " to " .. name) end
             if n.name == name then
                 if number <= 1 then
                     return n
                 else
                    number = number - 1
                end
             end
         end
    end
    error("no kid \"" .. name .. "\" with number " .. tostring(orignumber))
end

function implantkidfunction(element)
    element.kid = kid
    if not element.kids then return end
    for i,n in ipairs(element.kids) do
         implantkidfunction(n)
    end
end

util.file_watch("connections", function(content)
    myxml = content
    doc = dom:dom(myxml)
    print("blub, file changed")
    implantkidfunction(doc)
end)

function node.render()
    local i = 1
    local connections = doc:kid("request"):kid("connections").el
    local mitfussweg = function(connection)
         -- hat eine verbindung am anfang einen fussweg mit eingeplant?
         if #connection:kid("connection_parts"):kid("part"):kid("line").attr["id"] < 1 then
             -- keine zuglinien/buslinien-id => fussweg
             return true
         end
         return false
    end
    local abfahrtsstation = function(part)
        local stationen = part.el
        local i = 1
        while i <= #stationen do
            if stationen[i].name == "station" then
                if stationen[i].attr["used_for"] ~= nil then
                    if stationen[i].attr["used_for"] == "departure" then
                        -- gib bahnhofsname zurueck
                        return stationen[i]
                    end
                end
            end
            i = i + 1
        end
    end
    local abfahrtsbahnhof = function(connection)
        -- hilfsfunktion, um abfahrtsstelle von streckenteil zu kriegen:
        local abfahrtvonpart = function(part)
            -- finde station mit used_for="departure"
            return abfahrtsstation(part):kid("station_name").kids[1].value
        end
        -- nachgucken, ob strecke einen fussweg am anfang hat:
        if mitfussweg(connection) then
            -- zweite haltestelle zurueckgeben um fussweg zu skippen
            return abfahrtvonpart(connection:kid("connection_parts"):kid("part", 2))
        else
            -- regulaer erste haltestelle zurueckgeben
            return abfahrtvonpart(connection:kid("connection_parts"):kid("part", 1))
        end
    end
    local abfahrtsfahrzeug = function(connection)
        if mitfussweg(connection) then
            return connection:kid("connection_parts"):kid("part", 2):kid("line").kids[1].value
        else
            return connection:kid("connection_parts"):kid("part", 1):kid("line").kids[1].value
        end
    end
    local zeitohnesekunden = function(zeit)
        local secondcolon = string.find(zeit, ":", string.find(zeit, ":", 1, true)+1, true)
        return string.sub(zeit, 1, secondcolon-1)
    end
    local abfahrtszeit = function(connection)
        if mitfussweg(connection) then
            -- so da brauchen wa ne andre zeit, wa
            return abfahrtsstation(connections[i]:kid("connection_parts"):kid("part", 2)):kid("dateandtime"):kid("time").kids[1].value
        else
            return connection:kid("dateandtime"):kid("time").kids[1].value
        end
    end
    local lineheight = 55
    local x1 = 50  -- spalte 1
    local x2 = 250  -- spalte 2
    local x3 = 430 -- spalte 3
    local x4 = 560
    local ytitle = 70
    local ytable = 200
    local fontsize = 40
    font:write(10, ytitle, "OEPNV Monitor", 70,1,0,0,1)
    font:write(x1, ytable, "Uhrzeit", fontsize, 0, 1, 0, 1)
    font:write(x2, ytable, "Dauer", fontsize, 0, 1, 0,1)
    font:write(x3, ytable, "Ums.", fontsize, 0, 1, 0, 1)
    font:write(x4, ytable, "Haltestelle", fontsize ,0, 1, 0, 1)
    while i <= math.min(4, #connections)  do
        local y = (i) * 2*  lineheight
        font:write(x2, ytable + y, connections[i].attr["duration"], fontsize, 0, 1, 0, 1)
        font:write(x3, ytable + y, connections[i].attr["changes"], fontsize, 0, 1, 0, 1)
        font:write(x1, ytable + y, zeitohnesekunden(abfahrtszeit(connections[i])), fontsize, 0, 1, 0, 1)
        font:write(x4, ytable + y, abfahrtsbahnhof(connections[i]), fontsize, 0, 1, 0, 1)
        font:write(x4, ytable + y + lineheight, abfahrtsfahrzeug(connections[i]), fontsize, 0, 1, 0, 1)
        i = i + 1
    end
    --font:write(60, 300, #doc:kid("request"):kid("connections").el, 50, 1,0,0,1)
    --font:write(60, 400, "WG test", 80, 0,1,0,1)
   --sys.sleep(2000)
end

