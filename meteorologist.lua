addon.name      = 'meteorologist';
addon.author    = 'Matix and Hugin';
addon.version   = '4.0.0';
addon.desc      = 'Provides weather information in chat.';
addon.link      = 'https://github.com/clanofartisans/meteorologist';

require('common');
local chat = require('chat');

local weather;

weather_table = T{
    [0] = 'Clear',
    [1] = 'Sunshine',
    [2] = 'Clouds',
    [3] = 'Fog',
    [4] = 'Fire',
    [5] = 'Fire x2',
    [6] = 'Water',
    [7] = 'Water x2',
    [8] = 'Earth',
    [9] = 'Earth x2',
    [10] = 'Wind',
    [11] = 'Wind x2',
    [12] = 'Ice',
    [13] = 'Ice x2',
    [14] = 'Thunder',
    [15] = 'Thunder x2',
    [16] = 'Light',
    [17] = 'Light x2',
    [18] = 'Dark',
    [19] = 'Dark x2'
};

--[[
* Gets the current weather as a string.
--]]
local function get_weather()
    local pointer = ashita.memory.read_uint32(ashita.memory.find('FFXiMain.dll', 0, '66A1????????663D????72', 0, 0) + 0x02);
    local id = ashita.memory.read_uint8(pointer + 0);
	
	return weather_table[id];
end

--[[
* Prints the current weather to chat.
--]]
local function print_weather()
    weather = get_weather();
	
    print(chat.header(addon.name):append(chat.message('Current Weather - ')):append(chat.color1(6, weather)));
end

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    -- Parse the command arguments..
    local args = e.command:args();
    if (#args == 0 or (args[1] ~= '/weather')) then
        return;
    end

    -- Block all meteorologist related commands..
    e.blocked = true;
	
	print_weather();
	
	return;
end);

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
	coroutine.sleep(1);
		
	print_weather();
end);

--[[
* event: packet_in
* desc : Event called when the addon is processing incoming packets.
--]]
ashita.events.register('packet_in', 'packet_in_cb', function(e)
    if e.id == 0x000A then
		coroutine.sleep(1);
	
        print_weather();
    end
	
    if e.id == 0x057 then
		coroutine.sleep(1);
		
        print_weather();
    end
end)
