room {
    nam = 'main';
    disp = false;
    dsc = [[
        Эта история приключилась со мной, когда я работал на должности 'эникейщика' 
        в одной барнаульской фирме, название которой особого значения не имеет. 
        Это было в период 2009 -- 2010 гг. Сейчас этой фирмы уже нет. 
        Занималась она дистрибуцией продуктов питания, преимущественно молочной продукции ВБД.
        Периодически на фирме происходил п***ц разной степени тяжести,
        да и вообще работа там напоминала один большой п***ц. Хотя, справедливости ради,
        стоит отметить - были и спокойные деньки )^
        Один рабочий день мне особо запомнился, он как раз и послужил сюжетом для данной 
        игры. Игра основана на реальных автобиографических событиях! ^^
    ]];
    obj = { 
        obj {
            dsc = '{Желаю приятного квеста!}';
            act = function()
                take('achivs');
                take('mobile');
                walk('wplace');
            end;
        }; 
    };
};

room {
    nam = 'wplace';
    enter = function(s, f)
        if f.nam == 'cab6' then 
            return 'Я сел на свое рабочее место.'; 
        end;
    end;

    disp = 'Рабочее место';
    dsc = [[Я нахожусь в кабинете №6 за своим рабочим местом.]];
    obj = {
        -- vway('монитор', 'На столе стоит {монитор}.', 'screen'),
        'box'
    };
    way = { path {'Встать из за стола', 'cab6'} };
};

cab6 = room {
    enter = 'Я в кабинете № 6.';
    
    nam = 'cab6';
    disp = 'Кабинет №6';
    dsc = [[Это мой кабинет, но кроме меня тут еще сидят бухи и главбух.]];
    decor = [[ Около главбуха стоит {#принтер|принтер}. 
        В кабинете стоит мой {#стол|стол} с компьютером.
    ]];
    obj = {
        -- 'mfp1',
        obj {
            nam = '#стол';
            act = pfn(walk, 'wplace');
        };
        obj {
            nam = '#принтер';
            act = [[Принтер HP LJ 1300, старенький, но работает]];
        };
    };
    way = {
        -- 'lobby_end',
        'wplace'};
};