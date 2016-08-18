

-- table of anims
local anims = {};
local delay = 16; -- 60 FPS!
local running = false;
local ringSize = 11;
local ringCount = 6;
local buffer = ws2812.newBuffer(ringSize * ringCount, 3);

ws2812.init();


local function remove(name)
    anims[name] = nil;
end

local function executeAnims(time, dt, count)
    for name, anim in pairs(anims) do
        local keep = anim(buffer, ringSize, ringCount, time, dt, count);
        if not keep then
            print('stopping '..name);
            anims[name] = nil;
        end
    end
end

local function writeBuffer()
    ws2812.write(buffer);
end

local function loop()
    if not running then return end;

    print('loop');
    tmr.alarm(1, delay, 0, function()
        loop();
    end);
    executeAnims();
    writeBuffer();

--    print( "heap: " .. (node.heap()/1024) .. "k" );
end

local function run(name, func)
    if name and func then
        anims[name] = func;
    end

    if not running then
        running = true;
        loop();
    end
end


local function stop()
    running = false;
end

return {
    run = run,
    remove = remove,
    stop = stop
}
