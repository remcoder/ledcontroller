

-- table of anims
local anims = {};
local delay = 100; -- 60 FPS!
local buffer = {};
local running = false;
local ringSize = 11;
local ringCount = 6;

local function remove(name)
    anims[name] = nil;
end

local function executeAnims(time, dt, count)
    for name, anim in pairs(anims) do
        local keep = anim(buffer, ringSize, ringCount, time, dt, count);
        if not keep then
            anims[name] = nil;
        end
    end
end

-- NOTE: don't concat strings in a loop but use table.join instead
-- see: http://stackoverflow.com/questions/19138974/does-lua-optimize-the-operator
local function writeBuffer()
    -- TODO guard against improperly filled buffers: nodemcu will crash if no value at buffer[1]
    local s = table.concat(buffer)
    ws2812.writergb(1, s);
end


local function loop()
--    print(count);
    tmr.alarm(1, delay, 0, function()
        loop();
    end);
    executeAnims();
    writeBuffer();

    print( "heap: " .. (node.heap()/1024) .. "k" );
end

local function run(name, func)
    if name and func then
        anims[name] = func;
    end

    if not running then
        loop();
        running = true;
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
