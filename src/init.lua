print('- init ');

print('- switching to 115.2kbps now');
-- switching to 115200 b/s
-- this has to go at the start
uart.setup(0,115200,8,0,1);


local utils = require('utils');

-- turn all LEDs off first
utils.all(0,0,0, 100);

-- blink blue
utils.blink(0,0,255);

dofile('wifi.lua');


print('- starting main in 5 seconds..');

tmr.alarm(2, 5000, 0, function()

    utils.stopBlinking();

    xpcall(function()
        require('main');
    end,
    function(error)
        print('FATAL: '..error);
    end);

end);
