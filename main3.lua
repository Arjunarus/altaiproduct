-- $Name: Приключения эникейщика в ООО "Молоко"$
-- $Version: 0.3$
-- $Author: ArjunaRus - http://vk.com/arjunarus $

require "dbg"
require "fmt"

fmt.para = true

include "utils"

-- Defaults

game.act = 'Ничего не происходит';

game.inv = function(s,w)
    return rndItem({
        'Интересная штуковина..',
        'Хм..',
        'Как вы думаете, что это?',
        'Симпатичная вещица, не так ли?',
        'Забавная штука.',
        'Куда бы это применить?'
    })
end

game.use = function(s,w)
    return rndItem({
        'По-моему это сейчас не актуально',
        'Не пойму как это тут применить..',
        'Ну и причем тут ' .. w.disp .. '?',
        'Не срабатывает.',
        'Вряд ли это можно ' .. w.verb,
        'Да вы что, это же ' .. w.disp .. '!',
        'И чем нам тут поможет ' .. w.disp .. '?',
        'Можно конечно ' .. w.verb .. ', хм... думаете поможет?',
        'Лишь бы все ' .. w.verb .. '!'
    })
end

global {
    triggers = {
        weather = false;
        dirtyHands = true;
        wantToEat = false;
        needCopy = false;
        romantic = false;
        mainTask = true; -- true for debug purpose TODO change into false
        seenStockLine = false;
        openTechFloor = false;
    };
    
    achievs = {
        count = 0,
        
        eat = false,
        weather = false,
        copy = false,
        fix = false,
        romantic = false,
        main = false
    };
}

include "objects"
include "rooms"
include "dialogs"

-- Load saved state
function start(load)
end

function init()
    -- TODO
end


