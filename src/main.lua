
print('*** LEDstrip controller ***');

local utils = require('utils');
local server = require('httpserver');

ws2812.init();

function initWifi()
    utils.checkNetwork(server.run);
end

utils.testLength(66, 50, initWifi);
