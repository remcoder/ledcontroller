return function()
    local on = 0;
    local cycles = 1;
    local brightness = 256;
    local prev;
    local animator = require('animator');

    local function rotateBlue(buffer)
        if (brightness < 2) then
            if prev then
                buffer[prev * 3 + 3] = 0;
            end

            return false; -- stop animating
        end

        --    print(on);
        local b;
        if (brightness > 255) then
            b = 255;
        else
            b = brightness;
        end


        buffer[on * 3 + 3] = b;
        if prev then
            buffer[prev * 3 + 3] = 0;
        end

        prev = on;
        on = on+1;
        if (on > 7) then
            on = 0;
            cycles = cycles + 1;
            if ( cycles > 6) then
                brightness = brightness / 2;
            end
        end

        return true; -- continue animating
    end

    animator.run("rotate-blue", rotateBlue);

end
