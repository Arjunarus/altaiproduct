obj {
    verb = 'сфоткать на мобильник';
    nam = 'mobile';
    disp = 'мобильник';
    inv = 'Это мой мобильник Motorolla C650, старенький, такие сейчас не в моде.';  
};

stat {
    _value = 0;
    
    nam = 'achivs';
    disp = function(s) 
        return 'Достижения: ' .. s._value .. "^";
    end;
};


obj {
    nam = 'box';
    disp = 'Ящик стола';
    dsc = function (s)
            p "Выдвижной {ящик} в столе";
            if s:closed() then
                p "закрыт.";
            else
                p "открыт." 
                if #objs(s) ~= 0 then p "В ящике лежит " end;
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
    obj =  {'turn_screw','thermal_compound','lubricant'};
}:close();

obj {
    verb = 'раскрутить';
    nam = 'turn_screw';
    disp = 'отвертка';
    dsc = '{отвертка}';
    tak = 'Я взял отвертку.';
    inv = 'Обычная крестовая отвертка, универсальная :)';
};

obj {
    verb = 'намазать термопастой';
    nam = 'thermal_compound';
    disp = 'термопаста';
    dsc = '{термопаста}';
    tak = 'Я взял термопасту.';
    inv = 'Термопаста обеспечивает хорошую теплопроводность между процессором и радиатором.';
};

obj {
    verb = 'смазать';

    nam = 'lubricant';
    disp = 'смазка';
    dsc = '{смазка}';
    tak = 'Я взял смазку.';
    inv = 'Это смазка, чтобы кулеры не гудели (а не то, что вы подумали).';
};
