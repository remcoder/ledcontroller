print('- init ');

print('- switching to 115.2kbps now');
-- switching to 115200 b/s
-- this has to go at the start
uart.setup(0,115200,8,0,1);



print('- starting main in 5 seconds..');

tmr.alarm(2, 5000, 0, function()

    xpcall(function()
        require('main');
    end,
    function(error)
        print('FATAL: '..error);
    end);

end);
