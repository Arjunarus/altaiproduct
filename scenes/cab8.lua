room {
    nam = 'cab8';
    disp = 'Кабинет №8';
    decor = function()
        p 'Тут сидят обычные рядовые {бухи|бухи} и находится {#дверь|дверь} в серверную.'
        if seen('knife') then
            p 'На столе среди бумаг я заметил {knife|нож}.'
        end
    end;

    enter = 'Я вошел в кабинет № 8.';

    way = {
        'serv',
        'lobby_end'
    };

    obj = {'knife'};
    
}:with {
    obj {
        nam = 'бухи';
        act = 'И о чем поговорить с бухами, о дебетах и кредитах? Не интересно.'
    };

    obj {
        nam = '#дверь';
        act = pfn(walk, 'serv');
    };
};