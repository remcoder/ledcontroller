local animator = require('animator');

local on = 0;
local cycles = 1;
local brightness = 256;

local function rotateGreen(buffer, ringSize, ringCount)

    if (brightness < 2) then

        -- clear buffer
        for i = 1, ringSize*3 do
            buffer[i] = string.char(0);
        end

        print('stop anim')
        return false; -- stop animating
    end

    local b;
    if (brightness > 255) then
        b = 255;
    else
        b = brightness;
    end

    for i = 1, ringSize*3 do
        if i == on*3 + 2 then
            buffer[i] = string.char(b);
        else
            buffer[i] = string.char(0);
        end
    end

    on = on+1;
    if (on == ringSize) then
        on = 0;
        cycles = cycles + 1;
        if ( cycles > 6) then
            brightness = brightness / 2;
        end
    end

    return true;
end


animator.run("rotate-green", rotateGreen);
