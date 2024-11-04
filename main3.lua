-- $Name: Приключения эникейщика в ООО "Молоко"$
-- $Version: 0.3$
-- $Author: ArjunaRus - http://vk.com/arjunarus $

require "dbg"
require "fmt"

fmt.para = true

include "utils"

-- Defaults

game.act = 'Ничего не происходит';

game.inv = function(_,_)
    return rndItem({
        'Интересная штуковина..',
        'Хм..',
        'Как вы думаете, что это?',
        'Симпатичная вещица, не так ли?',
        'Забавная штука.',
        'Куда бы это применить?'
    })
end

game.use = function(_,what)
    return rndItem({
        'По-моему это сейчас не актуально',
        'Не пойму как это тут применить..',
        'Ну и причем тут ' .. what.disp .. '?',
        'Не срабатывает.',
        'Вряд ли это сейчас нужно ' .. what.verb,
        'Да вы что, это же ' .. what.disp .. '!',
        'И чем нам тут поможет ' .. what.disp .. '?',
        'Можно конечно ' .. what.verb .. ', хм... думаете поможет?',
        'Лишь бы все ' .. what.verb .. '!'
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
include "scenes"
include "dialogs"

-- Load saved state
function start(load)
end

function init()
    -- TODO
end


