-- $Name: Приключения эникейщика в ООО "Молоко"$
-- $Version: 0.3$
-- $Author: ArjunaRus - http://vk.com/arjunarus $

require "dbg"
require "fmt"

fmt.para = true

-- Defaults

rndItem = function(table)
    return table[rnd(#table)];
end;

inList = function(item, list)
    for ind, val in ipairs(list) do
        if val == item then
            return true;
        end;
    end;
    
    return false;
end;

rndExcept = function(max, exceptions)
    local res = 0;
    repeat
        res = rnd(max);
    until not inList(res, exceptions);
    
    return res;
end;

updateStat = function(statTable)
    local res = 0;
    for key, value in pairs(statTable) do
        if value == true then 
            res = res + 1; 
        end;
    end;
    
    statTable.count = res;
end;

game.act = 'Ничего не происходит';

game.inv = function(s,w)
    return rndItem({
        'Интересная штуковина..',
        'Хм..',
        'Как вы думаете, что это?',
        'Симпатичная вещица, не так ли?',
        'Забавная штука.',
        'Куда бы это применить?'
    });
end;

game.use = function(s,w)
    return rndItem({
        'По-моему это сейчас не актуально',
        'Не пойму как это тут применить..',
        'Ну и причем тут ' .. w.disp .. '?',
        'Не срабатывает.',
        'Засунуть туда? Наркоман штоле... О_о',
        'Да вы что, это же ' .. w.disp .. '!',
        'И чем нам тут поможет ' .. w.disp .. '?',
        'Можно конечно ' .. w.verb .. ', хм... думаете поможет?',
        'Ну конечно, вам лишь бы все ' .. w.verb .. '!'
    });
end;

global {
    triggers = {
        weather = false;
        dirtyHands = true;
        wantToEat = false;
        needCopy = false;
        romantic = false;
        mainTask = false;
        openTechFloor = false;
    };
    
    achievs = {
        count = 0,
        
        eat = false,
        weather = false,
        copy = false,
        fix = false,
        main = false
    };
};

include "objects"
include "rooms"
include "dialogs"

-- Load saved state
function start(load)
end;

function init()
    -- TODO
end;


