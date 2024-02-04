room {
    nam = 'wc1';
    disp = 'Туалет 1';
    dsc = 'Это обычный туалет';
    decor = [[Сбоку на стене приделана {sink|раковина} с кранами.
        В конце туалета, как и положено, расположен {pan|унитаз}.
        В двери вставлен {#wckey|ключ}.
    ]];
    enter = 'Я пришел в туалет';

    onexit = function()
        if _'#wckey':closed() then
            p 'Я не могу выйти, дверь закрыта'
            return false
        end
    end;

    obj = {'sink', 'pan'};

    way = {'lobby_start'};
}:with {
    obj {
        nam = '#wckey';
        disp = 'ключ';

        dsc = function(this)
            if this:closed() then
                p 'Дверь закрыта.'
            else
                p 'Дверь открыта.'
            end
        end;

        act = function(this)
            if this:closed() then
                this:open()
            else
                this:close()
            end
            return 'Я поворачиваю ключ.'
        end;
    }:open();
};

room {
    nam = 'wc2';
    disp = 'Туалет 2';
    dsc = 'Это обычный туалет';
    decor = [[Сбоку на стене приделана {sink|раковина} с кранами.
        В конце туалета, как и положено, расположен {pan|унитаз}.
        В двери вставлен {#wckey|ключ}.
    ]];
    enter = 'Я пришел в туалет';

    onexit = function()
        if _'#wckey':closed() then
            p 'Я не могу выйти, дверь закрыта'
            return false
        end
    end;

    obj = {'sink', 'pan'};

    way = {'lobby_start'};
}:with {
    obj {
        nam = '#wckey';
        disp = 'ключ';

        dsc = function(this)
            if this:closed() then
                p 'Дверь закрыта.'
            else
                p 'Дверь открыта.'
            end
        end;

        act = function(this)
            if this:closed() then
                this:open()
            else
                this:close()
            end
            return 'Я поворачиваю ключ.'
        end;
    }:open();
};