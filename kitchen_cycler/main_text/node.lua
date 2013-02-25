gl.setup(1024, 768)

font = resource.load_font("font.ttf")

function node.render()
    font:write(60, 300, "Freunde der Nacht", 80, 1,0,0,1)
    font:write(60, 400, "WG Monitor", 80, 0,1,0,1)
   --sys.sleep(2000)
end
