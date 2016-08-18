return function ()
    local Utils = require('utils');
    local buf = {};
    print('hello from lua script');
    for filename,size in Utils.pairsByKeys(file.list()) do
        if string.sub(filename, 1, 4) == 'pub/' then
            table.insert(buf, string.sub(filename, 5, -1)..'\n');
        end
    end

    return buf;
end
