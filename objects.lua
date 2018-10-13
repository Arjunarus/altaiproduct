require "table"
require "string"

stat {
    _value = 0;
    
    nam = 'achivs';
    disp = function(s) 
        return 'Достижения: ' .. s._value .. "^";
    end;
};

obj {
    nam = 'mobile';
    disp = 'мобильник';
    verb = 'сфотать на мобильник';
    tak = 'Я взял мобильник.';
    inv = 'Это мой мобильник Motorolla C650, старенький, такие уже давно не в моде.';  
};

obj {
    nam = 'box';
    disp = 'ящик стола';
    dsc = function (s)
            p "Выдвижной {ящик} в столе";
            if s:closed() then
                p "закрыт.";
            else
                p "открыт." 
                if #objs(s) ~= 0 then 
                    p "В ящике лежит ";
                    local obj_names = {};
                    for i = 1, #objs(s), 1 do
                        local obj = objs(s)[i]
                        table.insert(obj_names, string.format("{%s|%s}", obj.nam, obj.disp));
                    end;
                    p(table.concat(obj_names, ', ') .. '.');
                end;
            end;
    end;
    act = function (s)
            if s:closed() then
                s:open();
                p 'Я открыл ящик.';
            else
                s:close();
                p 'Я закрыл ящик.';
            end;
    end;
    
    used = function(s, f)
        if s:closed() then
            return game.use(s, f);
        else
            p 'Поместим-ка, пожалуй, это в ящик.'
            place(f, s);
        end;
    end;
    
    obj =  {'turn_screw','thermal_compound','lubricant'};
}:close();

obj {
    nam = 'weatherPaper';
    disp = 'распечатка погоды';
    dsc = 'В принтере лежит {распечатка погоды}.';
    
    _src = nil;
    _place = nil;
    verb = 'завернуть';

    
    act = 'Это распечатка погоды, директор попросил.';
    tak = 'Я взял распечатку погоды.';
    inv = 'Прогноз погоды на ближайшие дни.';
};

obj {
    nam = 'turn_screw';
    disp = 'отвертка';
    verb = 'раскрутить';
    tak = 'Я взял отвертку.';
    inv = 'Обычная крестовая отвертка, универсальная :)';
};

obj {
    nam = 'thermal_compound';
    disp = 'термопаста';
    verb = 'намазать термопастой';
    tak = 'Я взял термопасту.';
    inv = 'Термопаста обеспечивает хорошую теплопроводность между процессором и радиатором.';
};

obj {
    nam = 'lubricant';
    disp = 'смазка';
    verb = 'смазать';
    tak = 'Я взял смазку.';
    inv = 'Это смазка, чтобы кулеры не гудели (а не то, что вы подумали).';
};
