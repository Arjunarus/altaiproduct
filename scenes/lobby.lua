room {
    nam = 'lobby_end';
    disp = 'Конец коридора';
    dsc = [[Это самый конец коридора.]];

    enter = function(this,f)
        if f.name == 'lobby_middle' then
            return 'Я перешел в конец коридора.'
        else
            return 'Я вышел в коридор.'
        end
    end;

    way = {
        'lobby_middle',
        'cab6',
        'cab7',
        'cab8'
    };
};

room {
    nam = 'lobby_middle';
    disp = 'Середина коридора';
    dsc = [[Я стою посреди коридора, передо мной множество дверей.]];

    enter = function(this,f)
        if f.nam == 'lobby_end' or f.nam == 'lobby_start' then
            return 'Я прошел вдоль по коридору.'
        else
            return 'Я вышел в коридор.'
        end;
    end;

    way = {
        'lobby_start',
        'cab2',
        'cab3',
        'cab4',
        'cab5',
        'lobby_end'
    };
};

room {
    nam = 'lobby_start';
    disp = 'Начало коридора';
    dsc = [[Тут начинается коридор и видно несколько дверей.]];

    enter = function(this,f)
        if f.nam == 'lobby_middle' then
            return 'Я перешел в начало коридора.'
        elseif f.nam == 'porch' then
            return 'Я вошел в коридор нашей фирмы.'
        else
            return 'Я вышел в коридор.'
        end
    end;

    way = {
        'porch',
        'wc1',
        'wc2',
        'archiveroom',
        'cab1',
        'lobby_middle'
    };
};