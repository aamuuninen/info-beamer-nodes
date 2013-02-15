gl.setup(1024, 768)

font = resource.load_font("font.ttf")

function node.render()
    font:write(40, 40, "WG Preisliste", 100, 1,0,0,1)

    font:write(20, 200, "Urtrunk", 60, 0,1,0,1)
    font:write(550, 200, "75 cent", 60, 0,1,0,1)

    font:write(20,  300, "Rothaus", 60, 0,1,0,1)
    font:write(550, 300, "60 cent", 60, 0,1,0,1)

    font:write(20,  400, "Wodan", 60, 0,1,0,1)
    font:write(550, 400, "90 cent", 60, 0,1,0,1)

    font:write(20,  500, "Fritz", 60, 0,1,0,1)
    font:write(550, 500, "65 cent", 60, 0,1,0,1)

    font:write(20,  600, "Club Mate", 60, 0,1,0,1)
    font:write(550, 600, "80 cent", 60, 0,1,0,1)
end
