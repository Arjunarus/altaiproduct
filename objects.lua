require "table"
require "string"

stat {
    nam = 'status';
    disp = function()
        pn('Достижения: ' .. achievs.count);
        pn('==============');
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
            p 'Ящик закрыт, если что.';
            return false;
        else
            p 'Поместим-ка, пожалуй, это в ящик.'
            place(f, s);
        end;
    end;
    
    obj =  {
        'turn_screw', 
        'thermal_compound', 
        'lubricant'
    };
}:close();

obj {
	nam = 'someDocument';
    disp = 'какой-то документ';
    verb = 'завернуть';
    
	inv = 'Этот документ мне дали чтобы снять с него копию.';
    tak = 'Я взял документ.';
};

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

obj {
    nam = 'sink';
    disp = 'раковина',
    
    act = function()
        if _dirtyHands then
            _dirtyHands = false;
            return 'Я вымыл руки.';
        else
            return 'Руки еще не замарались, зачем их так часто мыть?';
        end;

    end,
};

obj {
    nam = 'pan';
    disp = 'унитаз';
    
    act = function()
        if not _'#wckey':closed() then
            return 'А вдруг кто-нибудь зайдет и увидит?';
        else
            return 'Вообще-то, я пока не хочу в туалет';
        end;
    end;
};