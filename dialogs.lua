require "noinv"

putWeather = function(src, place)
    if objs(cab6):srch(weatherPaper) == nil then
        _needWeather = false;
        local wPaper = weatherPaper;
        wPaper._src = src;
        wPaper._place = place;
        objs(cab6):add(wPaper);
    end;

    return;
end;

dlg {
    nam = 'screen';
    disp = 'Экран монитора (еще не готов уходи отсюда)';
    dsc = 'На экране запущен браузер. Я вижу перед собой несколько быстрых ссылок.';

    noinv = true;
    src = nil;

    printing = {'#weather', "Я ввожу в строке поиска ПОГОДА... На экране появляется несколько ссылок.",
        {'Погода в России. Распечатать', {'Я пускаю погоду на печать.', function() putWeather(screen.src, 'Россия'); end }},
        {'Погода в Москве. Распечатать', {'Я пускаю погоду на печать.', function() putWeather(screen.src, 'Москва'); end }},
        {'Погода в Барнауле. Распечатать', {'Я пускаю погоду на печать.', function() putWeather(screen.src, 'Барнаул'); end }},
    };

    phr = {
        {
            always = true,
            'vkontakte.ru',
            function()
                return rndItem({
                    'Я проверил сообщения в контакте.',
                    'Я добавил новых друзей.',
                    'Я написал письмо подружке.',
                    'Меня отметили на новых фотографиях.',
                    'Прочитал новое сообщение на стене.',
                    'Мою фотографию прокоментировали.'
                })
            end
        },
        {always = true, 'livejournal.com', 'В ЖЖ ничего нового.'},
        {
            always = true,
            'google.com', {
                {'hui', 'jigurda1'},
                {'pizda', 'jigurda2'}
            }
            -- function()
                -- if _needWeather then
                    -- return {"Я ввожу в строке поиска ПОГОДА... На экране появляется несколько ссылок.",
                        -- {'Погода в России. Распечатать', {'Я пускаю погоду на печать.', function() putWeather(screen.src, 'Россия'); end }},
                        -- {'Погода в Москве. Распечатать', {'Я пускаю погоду на печать.', function() putWeather(screen.src, 'Москва'); end }},
                        -- {'Погода в Барнауле. Распечатать', {'Я пускаю погоду на печать.', function() putWeather(screen.src, 'Барнаул'); end }},
                    -- }
                -- else
                    -- return rndItem({
                        -- 'Я зашел в гугл.',
                        -- 'Ну и чего будем искать?',
                        -- 'Надо ввести запрос. Хм..',
                        -- 'Погоду лучше смотреть в яндексе.'
                    -- })
                -- end
            -- end
        },
        {
            always = true,
            'yandex.ru',
            function()
                if _needWeather then
                    -- screen.src = 'Yandex';
                    return screen.printing;
                else
                    return rndItem({
                        'Я зашел в яндекс.',
                        'Что-то я забыл чего хотел найти...',
                        'Можно было бы скачать яндекс-браузер, но его еще не выпустили..'
                    })
                end
            end
        },
        {};

        -- {always = true, 'Назад', code = [[pret()]]}
    };

    way = {'wplace'};
};

dlg {
    nam = 'mfuPanel';
    disp = 'Ксерокопирование';
    dsc = 'На лицевой панели МФУ располагаются органы управления';

    copyMode = false;
    noinv = true;

	phr = {
		{
            always = true,

            'Кнопка переключения режима.',
            function()
                _'mfuPanel'.copyMode = not _'mfuPanel'.copyMode;
                if _'mfuPanel'.copyMode then
                    p 'Режим работы: копирование';
                else
                    p 'Режим работы: сканирование';
                end;
            end,
        },
		
        {
            always = true,

            'Кнопка копирования.',
            function()
                p 'Я нажал кнопку копирования...^^';

                if _'mfuPanel'.copyMode then
                    p 'МФУ стоит в режиме сканирования. В этом режиме копии не снимаются.';
                elseif _'mfpCover'.opened then
                    p 'Крышка МФУ открыта, в этом состоянии он не будет работать';
                elseif not disabled('jammedPaper') then
                    p 'Кажется внутри зажевана бумага, сначала надо ее вытащить.';
                elseif not _'mfpCover'.fixed then
                    enable('jammedPaper');
                    p 'Ну вот, МФУ зажевал бумагу. Он очень старый я ведь предупреждал!';
                else
                    remove('someDocument');
                    _'mfpCover'.fixed = false -- Only one copy is possible after fixing
                    achievs.copy = true;
                    updateStat(achievs);
                    disable('copyWoman')
                    p 'Ну все, кажется копия успешно снялась, УРА!';
                end;
                
                walkout();
            end;
        },
		
        {
            always = true,
            'Кнопки настройки изображения.',
            'Я настроил изображение получше. Хотя, вроде, и так было норм.'
        }
	};
};


dlg {
    nam = 'copyDlg';
	disp = 'Разговор с сотрудницей',
	enter = 'Одна из наших сотрудниц, чем-то серьезно озадачена, выглядит взволнованно';

    noinv = true;

    phr = {
        {
            cond = function()
                return have('someDocument');
            end,

            'Вы все еще тут?',
            'Да, нельзя ли побыстрее, мне срочно нужна копия!'
        },

        {
            cond = function()
                return not have('someDocument');
            end;
            
            'Чем-то помочь?',
            'Да, мне нужно отксерокопировать документ.',

            {
                'А что случилось с ксероксом в 4м кабинете?',
                'В нём закончился тонер',

                {
                    'Хм.. странно, вроде все было нормально...',
                    'Можно использовать ваш ксерокс? (показывает на МФУ возле моего стола)',

                    {
                        'Это плохой ксерокс, он жует бумагу, ну давайте попробуем.',

                        function ()
                            p '"Но мне нужна копия и очень срочно!" - с этими словами сотрудница вручила мне какой-то документ.'
                            take('someDocument');
                            walkout();
                        end;
                    }
                }
            },

            {
                'Ксерокс у нас находится в 4м кабинете.',
                'Тот ксерокс занят и надолго.'
            }
        }
    };
};

dlg {
    nam = 'cookerDlg';
    disp = 'Разговор с поваром';
    enter = 'Я подошел к нашему повару - не молодая женщина в переднике и косынке.';

    noinv = true;

    phr = {
        {
            '#hello',
            'Здравствуйте!',
            'Здравствуй!'
        },
        {
            only = true,

            cond = function()
                return disabled('vegaFood')
            end,

            'А нельзя ли что-нибудь съесть?',
            'Да, конечно, там на столе - это тебе. Приятного аппетита.',

            {
                'Но я же не ем мясное!',

                function ()
                    p 'Ой, прости, сейчас чтонибудь придумаем...';
                    enable('vegaFood');
                    close('#hello');
                end;
            },
            {
                'Спасибо!',
                'На доброе здоровье!'
            };
        }
    };

};