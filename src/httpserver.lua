local srv;
local Utils = require('utils');

local function writeInfo(buf)
    conn.send(Utils.printFiles(buf));

    conn.send("<br>");

    conn.send("<div><i>ip " ..wifi.sta.getip().."</i></div>");
    conn.send("<div><i>heap " ..(node.heap()/1024).."k</i></div>");

    local total, used, _ = file.fsinfo();
    conn.send("<div><i>"..(used/1000).."k used of "..(total/1024).."k total</i></div>");

    conn.send("<div><i>uptime "..Utils.prettyTime(tmr.time()).."</i></div>");
end

local function parseRequest(request)
    print(request);

    -- parse request
    local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");

    if (method == nil) then
        _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
    end

    local _GET = {}
    if vars ~= nil then
        for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
            _GET[k] = v
        end
    end

    path = string.sub(path, 2);

    if not path or path == '' then
        path = 'index.html'
    end

    path = 'pub/'..path;

    print(method..' ['..path..']');

    return method, path, vars;
end

local function run()
    print('- starting webserver');

    srv=net.createServer(net.TCP)
    srv:listen(80,function(conn)
        conn:on("receive", function(client,request)

            local method, path, vars = parseRequest(request);
            local files = file.list()

            if not files[path] then
                conn:send('HTTP/1.0 404 Not Found\r\n');
                client:close();
                return;
            end

            local response = {'HTTP/1.0 200 OK\r\nAccess-Control-Allow-Origin: *\r\nAccess-Control-Allow-Methods: OPTIONS, GET, POST, PUT, DELETE\r\n\r\n'};

            if method == 'GET' then
                print('- serving '..path);
                file.open(path, 'r');
                local content = file.read();
                print(content);
                table.insert(response, content);
                file.close();

            elseif method == 'POST' then
                if  Utils.isExecutable(path) then
                    print('- executing '..path);

                    -- TODO handle errors
                    local result = dofile(path)();

                    if result then
                        local str = table.concat(result);
                        print(str);
                        table.insert(response, str);
                    else
                        table.insert(response, 'OK');
                    end
                else
                    print('Cannot exec static file!');
                    table.insert(response, 'Cannot exec static file!');
                end
            elseif method == 'DELETE' then
                file.remove(path);
            elseif method == 'PUT' then
                -- save file
                print('saving file '..path);
            end

            -- flush buffer
            conn:send(table.concat(response));
            client:close();
        end)
    end)

    print('- webserver running');
end



return {
    run = run
};
