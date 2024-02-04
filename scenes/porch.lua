room {
    nam = 'porch';
    disp = 'Подъезд';
    dsc = 'Это можно назвать подъездом, тут ничего интересного';
    decor = [[Слева расположены {#ступеньки|ступеньки}, ведущие наверх.]];

    enter = function(this,f)
        if f.nam == 'main_enter' then
            return 'Я вошел в здание'
        else
            return 'Я вышел в подъезд'
        end
    end;

    way = {
        'main_enter',
        'upstairsSquare',
        'lobby_start'
    };

}:with {
    obj {
        nam = '#ступеньки';
        act = pfn(walk, 'upstairsSquare');
    };
};