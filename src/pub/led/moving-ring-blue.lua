return function()
local animator = require('animator');

local y = 0;
local dir = 1;
local steps = 5;
local startOfRing;
local endOfRing;
local lowIndex;
local highIndex;
local lowValue;
local highValue;

local function ring(index, ringSize, value, buffer)
    startOfRing = 1 + index* ringSize;
    endOfRing = startOfRing + ringSize - 1;

--    print('size '..buffer:size());

    for i = startOfRing, endOfRing do
        buffer:set(i, 0, 0, value);
    end
end

local function ringAliased(y, ringSize, value, buffer)
    lowIndex = y / steps;
    highIndex = lowIndex + 1;

    lowValue = (200/steps) * (steps - (y - lowIndex*steps));
    highValue = (200/steps) * (steps - (highIndex*steps - y));

--    print ('y: '..y..' low: '..lowValue..' high: '..highValue);
    ring(lowIndex, ringSize, lowValue, buffer);
    if highValue > 0 then
        ring(highIndex, ringSize, highValue, buffer);
    end
end

local function movingRing(buffer, ringSize, ringCount)
    -- clear buffer
    for i = 1, ringCount * ringSize do
        buffer:set(i, 0,0,0);
    end


    ringAliased(y, ringSize, 255, buffer);

    y = y+dir;

    if y == (ringCount-1) * steps or y == 0 then
        dir = -dir;
    end
    return true;
end

animator.run("moving-ring", movingRing);

end