return function (conn)
    conn:send(wifi.sta.getip());
    print(wifi.sta.getip());
end
