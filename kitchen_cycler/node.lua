gl.setup(1024, 768)

local interrupt_flag = nil
util.auto_loader(_G)


local interval = 10
-- set times in seconds for childs, default is *interval*
local special_nodes = {}
special_nodes['pricelist'] = 3
special_nodes['photos'] = 20
special_nodes['weather'] = 5
special_nodes['main_text'] = 2
special_nodes['analogclock'] = 3
-- set nodes which shoud be skiped (e.g. {'weather','clock',...})
local skip_nodes = {'barcodebeamer'}

local last_child = nil

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
        last_child = child
        child = childs.next()

       -- prevent double displaying of childs, fix a bug
       while last_child == child do
          child = childs.next()
       end

        -- check if the child has a special display time
        if special_nodes[child] == nil then
            next_switch = sys.now() + interval
        else
            next_switch = sys.now() + special_nodes[child] 
        end;
    end
    local function draw()
        if sys.now() > next_switch then
            next_child()
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
    local found = false
	-- if the child is to be ignored, then ignore
        for _,v in pairs(skip_nodes) do
           if v == child then
            -- do something
            found = ture
            break
          end
        end
        if found == false then
            table.insert(cycle, child)
        end
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
