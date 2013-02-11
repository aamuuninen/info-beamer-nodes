gl.setup(1920, 1080)

local interval = 10
local interrupt_flag = nil
util.auto_loader(_G)

util.data_mapper{
   ["interrupt/tonode"] = function(node)
  interrupt_flag = node
  end;
   ["interrupt/clear"] = function(foo)
    interrupt_flag = nil
    print ("interrupt flag cleared")
   end;
}

function make_switcher(childs, interval)
    local next_switch = 0
    local child
    local function next_child()
       print("switching child!")
        child = childs.next()
        next_switch = sys.now() + interval
    end
    local function draw()
        if sys.now() > next_switch then
            next_child()
	    -- if the child is to be ignored, then ignore
	    if child == "barcodebeamer" then
	       print("skipping child")
	       next_child()
	       end
	    print("Child name:" .. child )
	 end
        util.draw_correct(resource.render_child(child), 0, 0, WIDTH, HEIGHT)	    

        local remaining = next_switch - sys.now()
    end
    return {
        draw = draw;
    }
end

local switcher = make_switcher(util.generator(function()
    local cycle = {}
    for child, updated in pairs(CHILDS) do
        table.insert(cycle, child)
    end
    return cycle
end), interval)

function node.render()

    gl.clear(0, 0.02, 0.2, 1)
    if interrupt_flag == nil then
        switcher.draw()
     else
        local child = interrupt_flag
        print ("Recieved interrupt, binding to child: ".. tostring(child))
	util.draw_correct(resource.render_child(child), 0, 0, WIDTH, HEIGHT)	    
    end
end
