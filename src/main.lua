
print('*** pingpongnotify ***');

local utils = require('utils');
local server = require('httpserver');

utils.checkNetwork(server.run);
