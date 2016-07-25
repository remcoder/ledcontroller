
local function divmod(a,b)
    local remainder = a % b;
    return (a-remainder) / b, remainder;
end

local function prettyTime(timeInSeconds)
    local seconds, minutes, hours, days, weeks;

    minutes, seconds = divmod(timeInSeconds, 60);
    hours, minutes = divmod(minutes, 60);
    days, hours = divmod(hours, 24);
    weeks, days = divmod(days,7);

    local result = "";

    result = result..weeks.." weeks, ";

    result = result..days.." days, ";

    result = result..hours.." hours, ";

    result = result..minutes.." minutes and ";

    result = result..seconds.." seconds";

    return result;

end

local function led(r,g,b)
    ws2812.writergb(1, string.char(r,g,b));
end

-- blink the first LED. useful for status
local function blink(r,g,b)
    --    delay = delay or 1000;
    --    times = times or 1;
    --    stayOn = stayOn or false;
    local ledOn = true;
    tmr.alarm(1, 500, tmr.ALARM_AUTO, function()
        if ledOn then
            led(r,g,b);
        else
            led(0,0,0);
        end
        ledOn = not ledOn;
    end);
end

local function once(r,g,b, delay)
    led(r,g,b);

    tmr.stop(1);

    -- turn off after x sec
    tmr.alarm(1, delay, 0, function()
        led(0,0,0);
    end)
end



local function blinkOrange()
    blink(255,64,0);
end

local function stopBlinking()
    tmr.stop(1);
end

local toggleOrange = coroutine.wrap(function()
    local on = false;
    while true do
        if on then
            led(255,64,0);
        else
            led(0,0,0);
        end
        on = not on;
        coroutine.yield();
    end
end);

local function checkNetwork(onConnect)
    toggleOrange();

    tmr.alarm(2, 100, tmr.ALARM_AUTO, function()
        print('- checking network');
        toggleOrange();
        local status = wifi.sta.status();
        if status == 5 then
            print('- network ok');
            stopBlinking();
            once(0,255,0, 3000);
            tmr.stop(2);
            print(wifi.sta.getip());
            onConnect();
        end

        if status >= 2 and status <= 4 then
            print('- network error '..status);
            blink(255,0,0);
            tmr.stop(2);
        end
    end)
end

local function all(r,g,b, n)
    local buffer = '';

    for _=1, n  do
        buffer = buffer..string.char(r,g,b);
    end


    ws2812.writergb(1, buffer);
end

local function firstOnly(r,g,b, n)
    ws2812.write(1, string.rep(string.char(0), (n-1)*3 ) .. string.char(r,g,b));
end

local function testLength(length, delay)
    local current = 1;
    tmr.alarm(1, delay, tmr.ALARM_AUTO, function()
        if current == 1 then
            all(0,0,0, length)
        end

        firstOnly(255,255,255, current);
        current = current + 1;
        if current > length then
            current = 1;
        end
    end);
end


local function randomize(length, delay)
    local index;
    local color;
    tmr.alarm(1, delay, tmr.ALARM_AUTO, function()
        index = math.random(1, length);
        color = string.char(math.random(255), math.random(255), math.random(255));
        ws2812.writergb(1, string.rep(string.char(0), (index-1)*3 ) .. color .. string.rep(string.char(0), (length-index)*3 )  );
    end);
end

local function isExecutable(path)
    return string.find(path, 'patterns/', 1, true) or string.find(path, 'commands/', 1, true);
end

-- traverse a table alphabetically. see: https://www.lua.org/pil/19.3.html
local function pairsByKeys (t, f)
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
    table.sort(a, f)
    local i = 0      -- iterator variable
    local iter = function ()   -- iterator function
    i = i + 1
    if a[i] == nil then return nil
    else return a[i], t[a[i]]
    end
    end
    return iter
end

local function printFiles(buf)
    for filename,size in pairsByKeys(file.list()) do

        buf = buf.."<div>";
        if isExecutable(filename) then
            buf = buf.."<a href='/"..filename.."'>"..filename.."</a>";
        else
            buf = buf..filename;
        end
        buf = buf.." ("..size.." bytes)</div>";
    end

    return buf;
end

return {
    all = all,
    blink = blink,
    blinkOrange = blinkOrange,
    checkNetwork = checkNetwork,
    firstOnly = firstOnly,
    isExecutable = isExecutable,
    led = led,
    once = once,
    pairsByKeys = pairsByKeys,
    prettyTime = prettyTime,
    printFiles = printFiles,
    randomize = randomize,
    stopBlinking = stopBlinking,
    testLength = testLength
};
