gl.setup(1920, 1080)

local interval = 10
local interrupt_flag = nil
util.auto_loader(_G)

util.data_mapper{
  ["interrupt/tonode"] = function(node)
    
  print("recieved interrupt to node: ".. tostring(node))
  interrupt_flag = node
  end;
   ["interrupt/clear"] = function(foo)
    interrupt_flag = nil
   end;
}

local distort_shader = resource.create_shader([[
    void main() {
        gl_TexCoord[0] = gl_MultiTexCoord0;
        gl_FrontColor = gl_Color;
        gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    }
]], [[
    uniform sampler2D tex;
    uniform float effect;
    void main() {
        vec2 uv = gl_TexCoord[0].st;
        vec4 col;
        col.r = texture2D(tex,vec2(uv.x+sin(uv.y*20.0*effect)*0.2,uv.y)).r;
        col.g = texture2D(tex,vec2(uv.x+sin(uv.y*25.0*effect)*0.2,uv.y)).g;
        col.b = texture2D(tex,vec2(uv.x+sin(uv.y*30.0*effect)*0.2,uv.y)).b;
        col.a = texture2D(tex,vec2(uv.x,uv.y)).a;
        vec4 foo = vec4(1,1,1,effect);
        col.a = 1.0;
        gl_FragColor = gl_Color * col * foo;
    }
]])

function make_switcher(childs, interval)
    local next_switch = 0
    local child
    local function next_child()
        child = childs.next()
        next_switch = sys.now() + interval
    end
    local function draw()
        if sys.now() > next_switch then
            next_child()
        end
        util.draw_correct(resource.render_child(child), 0, 0, WIDTH, HEIGHT)	    

        local remaining = next_switch - sys.now()
        if remaining < 0.2 or remaining > interval - 0.2 then
            util.post_effect(distort_shader, {
                effect = 5 + remaining * math.sin(sys.now() * 50);
            })
        end
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
        print ("Child: ".. tostring(child))
	util.draw_correct(resource.render_child(child), 0, 0, WIDTH, HEIGHT)	    
    end
end
