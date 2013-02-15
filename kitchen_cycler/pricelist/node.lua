gl.setup(1024, 768)

font = resource.load_font("font.ttf")

function node.render()
    font:write(140, 40, "WG Preisliste", 100, 1,0,0,1)

    font:write(120, 200, "Urtrunk", 60, 0,1,0,1)
    font:write(650, 200, "75 cent", 60, 0,1,0,1)

    font:write(120,  300, "Rothaus", 60, 0,1,0,1)
    font:write(650, 300, "60 cent", 60, 0,1,0,1)

    font:write(120,  400, "Wodan", 60, 0,1,0,1)
    font:write(650, 400, "90 cent", 60, 0,1,0,1)

    font:write(120,  500, "Fritz", 60, 0,1,0,1)
    font:write(650, 500, "65 cent", 60, 0,1,0,1)

    font:write(120,  600, "Club Mate", 60, 0,1,0,1)
    font:write(650, 600, "80 cent", 60, 0,1,0,1)
end
