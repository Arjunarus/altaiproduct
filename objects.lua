require "table"
require "string"

stat {
    nam = 'status';
    disp = function()
        pn('Достижения: ' .. achievs.count);
    end;
};

obj {
    nam = 'mobile';
    disp = 'мобильник';
    verb = 'сфотать на мобильник';
    tak = 'Я взял мобильник.';
    inv = function(this)
        if this.calling then
            this.selections[this.selector]();
            if this.selector < #this.selections then
                this.selector = this.selector + 1;
            end;
            this.last_time = time();
            this.calling = false;
        else
            p 'Это мой мобильник Motorolla C650, старенький, такие уже давно не в моде.';
        end;
    end;
    
    calling = false;
    CALL_INTERVAL = 25;
    selector = 1;
    last_time = 0;
    
    selections = {
        [1] = function()
            walkin('kateDlg');
        end;
        
        [2] = function()
            walkin('principalDlg_1');
            triggers.weather = true;
        end;
        
        [3] = function()
            local pos = string.sub(where('player').nam, -1);
            dprint('My pos ' .. pos);
            local cab = rndExcept(8, {2, pos});
            
            _'badPcDlg'.number = cab;
            walkin('badPcDlg');
            place('badpc', 'cab' .. cab);
        end;
        
    };

    life = function(this)
        if not this.calling 
            and this.selector <= #this.selections
            and rnd(time()) - this.last_time > this.CALL_INTERVAL 
        then
            this.calling = true;
        end;
        
        if this.calling then
            p 'У меня звонит мобильник!';
        end;
        
        -- Enable hunger
        if not achievs.eat and rnd(time()) > this.CALL_INTERVAL * 1.5 then
            triggers.wantToEat = true;
        end;
        
        if triggers.wantToEat and rnd(time()) % 3 == 0 then
            p 'Что-то я проголодался, надо бы поесть...';
        end;
    end;
};

obj {
    nam = 'badpc';
    disp = 'сломанный комп';
    dsc = 'Мне указывают на сломаный {комп} в кабинете.';
    act = function(this)
        -- TODO complex fixing
        p 'Я починил комп';
        achievs.fix = true;
        updateStat(achievs);
        remove('badpc');
    end;
    
    power = false;
    mother = false;
    ram_1 = false;
    ram_2 = false;
    hard = false;
    cpu = false;
    cooler = false;
    video = false;
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
    nam = 'knife';
    disp = 'нож';
    verb = 'порезать';
    tak = 'Я взял нож.';
    inv = 'Обычный канцелярский нож.';
};

obj {
    nam = 'tape';
    disp = 'изолента';
    verb = 'обмотать';
    tak = 'Я взял изоленту.';
    inv = 'Знаменитая синяя изолента, которой можно починить все!';
};

obj {
    nam = 'landline_phone';
    disp = 'дисковый телефон';
    verb = 'позвонить';
    tak = function()
        if triggers.mainTask then
            p 'Пожалуй, мне он может понадобится. Я отсоединяю кабель и беру в руки аппарат.';
        else
            p(rndItem({
                'Если кому-то срочно понадобится сисадмин, он может вызвать его по внутреннему номеру.',
                'Мне никого не нужно вызывать.',
                'Честно говоря, я наших локальных номеров еще не помню - недавно на работу устроился.',
                'Можно попробовать набрать номер наугад и бросить трубку, но лучше не надо.',
                'Внутренние номера, вроде, четырехзначные...'
            }));
            return false;
        end;
    end;
    inv = 'Красный дисковый телефон. Такими пользовались еще в СССР. Сзади разьем для кабеля.';
};

obj {
    nam = 'handset';
    disp = 'телефонная трубка';
    verb = 'подключить';
    tak = 'Я взял телефонную трубку';
    inv = 'Простая телефонная трубка, из которой торчат два провода';
};

obj {
    nam = 'sink';
    disp = 'раковина',

    act = function()
        if triggers.dirtyHands then
            triggers.dirtyHands = false;
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