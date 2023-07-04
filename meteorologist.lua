_addon.author     = 'Matix';
_addon.name        = 'meteorologist';
_addon.version     = '3.0.1';
require 'common'
require 'ffxi.weather'
require 'ffxi.enums'
local weather;
local function get_weather_name(weather_enum)
    for k,v in pairs(WeatherType) do
        if (v == weather_enum) then
            return k;
        end
    end    
end
local function get_current_weather()
    for k,v in pairs(WeatherType) do
        if (v == ashita.ffxi.weather.get_weather()) then
            return k;
        end
    end    
end
ashita.register_event('load', function()
    weather = get_current_weather();
    print(string.format('Current Weather [%s]',weather));
end );
ashita.register_event('incoming_packet', function( id, size, packet, modified, block )
    if (id == 0x057) then        
        local weather_type        = struct.unpack('B', packet, 0x08+0x01)
        weather = get_weather_name(weather_type)
        print(string.format('Weather Change [%s]',weather));
    end
    return false;
end);
ashita.register_event('outgoing_packet', function( id, size, packet, modified, block )
    if (id == 0x00C) then        
        print(string.format('Current Weather [%s]',get_current_weather()));
    end
    return false;
end);
ashita.register_event('command', function(cmd, nType)
    local args = cmd:args();    
    if (args[1] == '/weather') then
        print(string.format('Current Weather [%s]',get_current_weather()));
        return true;
    end
    return false;
end );=