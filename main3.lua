-- $Name: Приключения эникейщика в ООО "Молоко"$
-- $Version: 0.3$
-- $Author: ArjunaRus - http://vk.com/arjunarus $

require "dbg"
require "fmt"

include "objects"
include "rooms"
include "dialogs"

fmt.para = true

-- Defaults

rndItem = function(table)
    return table[rnd(#table)];
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
        'Наркоман штоле...',
        'Да вы что, это же ' .. w.disp .. '!',
        'И чем нам тут поможет ' .. w.disp .. '?',
        'Можно конечно ' .. w.verb .. ', хм... думаете поможет?',
        'Ну конечно, давайте все ' .. w.verb .. '!'
    });
end;

function start(load)
end;

global {
    _needWeather = false;
    _dirtyHands = true;
}

function init()
end;


