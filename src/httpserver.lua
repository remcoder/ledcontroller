local srv;
local Utils = require('utils');

local function writeInfo(buf)
    buf = Utils.printFiles(buf);

    buf = buf.."<br>";

    buf = buf.."<div><i>ip " ..wifi.sta.getip().."</i></div>";
    buf = buf.."<div><i>heap " ..(node.heap()/1024).."k</i></div>";

    local total, used, _ = file.fsinfo();
    buf = buf.."<div><i>"..(used/1000).."k used of "..(total/1024).."k total</i></div>";

    buf = buf.."<div><i>uptime "..Utils.prettyTime(tmr.time()).."</i></div>";

    return buf;
end

local function run()
    print('- starting webserver');

    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive", function(client,request)

            local function endResponse(buffer)
                client:send(buffer);
                client:close();
            end

            -- parse request
            local buf = "";
            local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");

            if (method == nil) then
                _, _, _, path = string.find(request, "([A-Z]+) (.+) HTTP");
            end

            local _GET = {}
            if vars ~= nil then
                for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                    _GET[k] = v
                end
            end

            path = string.sub(path, 2);

            -- ignore favicon
            if (path=='favicon.ico') then
                endResponse(buf);
                return;
            end

            print(path);

            buf = buf.."<h1>Pingpong Notify</h1>";

            if (path=='status') then
                buf = writeInfo(buf);
            end
            endResponse(buf);

            if path and Utils.isExecutable(path) then
                -- find file and execute it
                local files = file.list()

                if files[path]  then
                    print('- executing '..path);
                    dofile(path);
                end
            end
        end)
    end)

    print('- webserver running');
end



return {
    run = run
};
