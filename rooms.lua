room {
    nam = 'main';
    disp = 'Приключения эникейщика в ООО "Молоко"';
    dsc = [[
        Эта история приключилась со мной, когда я работал на должности 'эникейщика' 
        в одной барнаульской фирме в период 2009 -- 2010 гг. Сейчас этой фирмы уже нет. 
        Занималась она дистрибуцией продуктов питания, преимущественно молочной продукции ВБД.
        Периодически, на фирме происходил п***ц разной степени тяжести: то потоп - отопление прорвало, 
        то пожар - электрики в проводке напутали ну и все в таком роде ))^
        Один рабочий день мне особо запомнился, он и послужил сюжетом для данной 
        игры. Игра основана на реальных автобиографических событиях! ^^
    ]];
    
}:with {
    obj {
        dsc = '{Желаю приятного квеста!}';
        act = function()
            take('achivs');
            take('mobile');
            -- take('weatherPaper')
            walk('wplace');
        end;
    };
};

room {
    nam = 'wplace';
    disp = 'Рабочее место';
    dsc = [[Я нахожусь в кабинете №6 за своим рабочим местом.]];
    
    enter = function(s, f)
        if f.nam == 'cab6' then 
            return 'Я сел на свое рабочее место.'; 
        end;
    end;
    
    way = { 
        path {'Встать из за стола', 'cab6'} 
    };
    
}:with {
    obj {
        nam = 'монитор';
        dsc = [[На столе стоит небольшой {монитор}.]];
        act = pfn(walkin, 'screen');
    };
};

room {
    nam = 'cab6';
    disp = 'Кабинет №6';
    dsc = [[Это мой рабочий кабинет, но кроме меня тут еще сидят бухи и главбух.]];
    decor = [[В кабинете стоит мой {стол|стол} с компьютером. Около главбуха стоит {принтер|принтер}.
        Рядом со столом стоит старое {mfp_1|МФУ Sharp}.
    ]];
    
    enter = function(s, f)
        if f.nam == 'wplace' then 
            return 'Я встал из-за стола.'; 
        end;
        return 'Я в кабинете № 6.';
    end;
    
    way = {
        'lobby_end',
        'wplace'
    };
    
}:with {
    obj {
        nam = 'mfp_1';
        act = [[Старая МФУ-шка, уже снятая с производства, модель Sharp AL-1217.]];
        -- TODO
    };
    obj {
        nam = 'стол';
        act = pfn(walk, 'wplace');
        obj = {'box'};
    };
    obj {
        nam = 'принтер';
        act = [[Принтер HP LJ 1300, старенький, но работает]];
    };
};

room {
    nam = 'lobby_end';
    disp = 'Конец коридора';
    dsc = [[Это самый конец коридора.]];
    
    enter = function(s,f)
        if f.name == 'lobby_middle' then
            return 'Я перешел в конец коридора.';
        else
            return 'Я вышел в коридор.';
        end;
    end;

    way = {
        'cab8',
        'cab7',
        'cab6',
        'lobby_middle'
    };
};

room {
    nam = 'cab7';
    disp = 'Кабинет №7';
    dsc = 'Тут заседают логисты, и еще тут часто рубятся в ирушки';
    enter = 'Я вошел в кабинет № 7';
    way = {'lobby_end'};
};

room {
    nam = 'cab8';
    disp = 'Кабинет №8';
    decor = [[Тут сидят обычные рядовые {бухи|бухи} и находится {#дверь|дверь} в серверную.]];
    
    enter = 'Я вошел в кабинет № 8.';
    
    way = {
        'lobby_end',
        'serv'
    };
    
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

room {
    nam = 'serv';
    disp = 'Серверная';
    dsc = [[То ли серверная, то ли кладовка, здесь полно всякого хлама.]];
    decor = [[На подставке стоит {сервер|сервер}. На сервере сверху стоит еще один {шлюз|системник} - это наш шлюз в интернет.^
        На стене висит {МиниАТС|мини АТС} фирмы Panasonic, к ней подходит куча проводов.^
        Еще на стене висят {Свитчи|два свитча} D-Link, тоже с кучей проводов.^
        Неподалеку от свитчей, тоже на стене прикреплены {Автомат|автоматы} электропитания.^
        На другой стене висит большой и страшный {Отопление|агрегат} - это система автономного отоплления.
    ]];
    
    enter = 'Я вошел в серверную, тут довольно тесно.';
    
    way = {'cab8'};
}:with {
    obj {
        nam = 'сервер';
        act = 'Сервер без монитора, так что ничего интересного я тут не увижу.';
    };
    obj {
        nam = 'шлюз';
        act = 'Старенький системник с Linux-ом, обеспечивает безопасный доступ в инет и больше ничего.';
    };
    obj {
        nam = 'МиниАТС';
        act = 'Мини-АТС, сюда подходят провода от всех аппаратов фирмы, а также 3 городские линии.';
    };
    obj {
        nam = 'Свитчи';
        act = 'Свитчи тоже лучше не трогать, пока все работает.';
    };
    obj {
        nam = 'Автомат';
        act = function(s)
            return rndItem({
                'Можно конечно поотрубать свет в каких-то отделах, но боюсь меня за это не похвалят.',
                'Таки напросимся на неприятности, со своими шуточками.',
                'Можно потестить методом тыка, за какой отдел какой автомат отвечает...'
            });
        end;
    };
    obj {
        nam = 'Отопление';
        act = function(s)
            return rndItem({
                'Лучше не трогать этот страшный девайс.',
                'А что, может отопление отключим? Гыыы ))',
                'Все равно сейчас не отопительный сезон.'
            });
        end;
    };
};

room {
    nam = 'lobby_middle';
    disp = 'Середина коридора';
    dsc = [[Я стою посреди коридора, передо мной множество дверей.]];
    
    enter = function(s,f)
        if f.nam == 'lobby_end' or f.nam == 'lobby_start' then
            return 'Я прошел вдоль по коридору.';
        else
            return 'Я вышел в коридор.';
        end;
    end;

    way = {
        'cab5',
        'cab4',
        'cab3',
        'cab2',
        'lobby_end',
        'lobby_start'
    };
};

room {
    nam = 'cab5';
    disp = 'Кабинет №5';
    dsc = 'Тут работает наш кассир, и еще иногда выдают зарплату, но не сегодня';
    enter = 'Я вошел в кабинет № 5';
    way = {'lobby_middle'};
};

room {
    nam = 'cab4';
    disp = 'Кабинет №4';
    dsc = 'Это самый главный кабинет.';
    decor = [[Тут трудятся {диспетчера|диспетчера}!^
        Посреди кабинета у стены стоит здоровое {МФУ|МФУ}.
    ]];
    
    enter = 'Я вошел в кабинет № 4';

    way = {'lobby_middle'};
    
}:with {
    obj {
        nam = 'диспетчера';
        act = function()
            p 'Диспетчера "вежливо" попросили не мешать работать, лучше их не злить.';
            walk('lobby_middle');
        end;
    };
    obj {
        nam = 'МФУ';
        act = 'МФУ Kyocera TaskAlfa 180 формата А3, японская, как видно из названия :)';
        used = function(s, w)
            if w.nam == 'someDocument' then
                p 'Тонер закончился, так что снять копию не получится.';
            else
                p(rndItem({
                    'Предлагаете ' .. w.verb .. ' МФУ? Хм... ну не знаю, не знаю...',
                    'Можно конечно ' .. w.verb .. ' МФУ, можно еще и диспетчеров ' .. w.verb .. '.'
                }));
            end;
        end;
    };
};

room {
    nam = 'cab2';
    disp = 'Кабинет №2';
    dsc = 'Кабинет директора, тоже очень главный!! отсюда часто доносятся громкие крики...';
    decor = [[За крутым директорским столом, на крутом кожаном кресле сидит наш директор -- {Директор|Михалыч}]];
    
    onenter = function(s, w)
        if have('weatherPaper') == nil then
            p 'Это кабинет директора, лучше туда не заходить просто так.'
            return false;
        else
            return 'Я вошел в кабинет № 2.';
        end;
    end;

    way = {'lobby_middle'};
    
}:with {
    obj {
        nam = 'Директор';
        act = 'Нужна веская причина чтобы отвлекать директора.';
        used = function(s, w)
            if w.nam == 'weatherPaper' then
                p 'TODO: диалог о погоде';
                -- walkin(weatherDlg);
            end;
        end;
    };
};

room {
    nam = 'cab3';
    disp = 'Кабинет №3',
    dsc = 'Кабинет колбасного отдела.',
    enter = 'Я вошел в кабинет № 3.',
    way = {'lobby_middle'};
};

room {
    nam = 'lobby_start';
    disp = 'Начало коридора';
    dsc = [[Тут начинается коридор и видно несколько дверей.]];
    
    enter = function(s,f)
        if f.nam == 'lobby_middle' then
            return 'Я перешел в начало коридора.';
        elseif f.nam == 'porch' then
            return 'Я вошел в коридор нашей фирмы.';
        else
            return 'Я вышел в коридор.';
        end;
    end;
    
    way = {
        -- 'cab1',
        'porch',
        'lobby_middle',
        -- 'wc1',
        -- 'wc2',
        -- 'archiveroom'
    };
};

room {
    nam = 'porch';
    disp = 'Подъезд';
    dsc = 'Это можно назвать подъездом, тут ничего интересного';
    decor = [[Сбоку расположены {Ступеньки|ступеньки}, ведущие наверх.]];
    
    enter = function(s,f)
        if f.nam == 'main_enter' then
            return 'Я вошел в здание';
        else
            return 'Я вышел в подъезд';
        end;
    end;
    
    way = {
        'lobby_start',
        -- 'main_enter',
        -- 'upstairsSquare'
    };
    
}:with {
    obj {
        nam = 'Ступеньки';
        act = pfn(walk, 'upstairsSquare');
    };
};