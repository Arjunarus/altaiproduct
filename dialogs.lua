require "noinv"

putWeather = function(src, place)
    _'weatherPaper'.src = src;
    _'weatherPaper'.place = place;
    
    enable('weatherPaper');
    walkout();
end;

dlg {
    nam = 'screen';
    disp = 'Экран монитора';
    dsc = 'На экране запущен браузер. Я вижу перед собой несколько быстрых ссылок.';

    noinv = true;
    src = '';
    place = '';

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

        {
            always = true,
            'livejournal.com',
            'В ЖЖ ничего нового.'
        },

        {
            always = true,

            'google.com',
            function()
                if needWeather and disabled('weatherPaper') then
                    _'screen'.src = 'Google';
                    push('#weather');
                else
                    return rndItem({
                        'Я зашел в гугл.',
                        'Ну и чего будем искать?',
                        'Надо ввести запрос. Хм..',
                        'Погоду лучше смотреть в яндексе.'
                    });
                end
            end,


        },
        {
            always = true,
            'yandex.ru',

            function()
                if needWeather and disabled('weatherPaper') then
                    _'screen'.src = 'Yandex';
                    push('#weather');
                else
                    return rndItem({
                        'Я зашел в яндекс.',
                        'Что-то я забыл чего хотел найти...',
                        'Можно было бы скачать яндекс-браузер, но его еще не выпустили..'
                    })
                end
            end
        },

        {
            '#weather',
            hidden = true,

            'Я ввожу в строке поиска ПОГОДА... На экране появляется несколько ссылок.',

            {
                always = true,
                'Погода в России.',
                function()
                    _'screen'.place = 'Россия';
                    push('#actions');
                end
            },

            {
                always = true,
                'Погода в Москве.',
                function()
                    _'screen'.place = 'Москва';
                    push('#actions');
                end
            },
            
            {
                always = true,
                'Погода в Новосибирске.',
                function()
                    _'screen'.place = 'Новосибирск';
                    push('#actions');
                end
            },

            {
                always = true,
                'Погода в Барнауле.',
                function()
                    _'screen'.place = 'Барнаул';
                    push('#actions');
                end
            },
            
            {
                always = true,
                'Назад',
                pfn(pop)
            }
        },
        
        {
            '#actions',
            hidden = true,
            
            {
                always = true,
                'Посмотреть',
                function()
                    if _'screen'.place == 'Барнаул' then
                        p 'Я смотрю погоду, хмм... завтра будет тепло, можно будет погулять с Катей после работы.';
                    else
                        return rndItem({
                            'Не знаю зачем мне смотреть погоду хрен пойми где.. ну да ладно.',
                            'Я посмотрел погоду.',
                            'Вроде обещают тепло.',
                            'Через 2 дня будет дождь.',
                            'Переменная облачность, без осадков.'
                        });
                    end;
                end
            },
            
            {
                'Распечатать',
                function()
                    p 'Я пускаю погоду на печать.';
                    putWeather(_'screen'.src, _'screen'.place);
                end
            },
            
            {
                always = true,
                'Назад',
                pfn(pop)
            }
        }
    };

    way = {'wplace'};
};

dlg {
    nam = 'weatherDlg';
    disp = 'Разговор с директором';
    dsc = 'Ну что принес погоду?';

    noinv = true;

    phr = {
        only = true,

        {
            cond = function()
                return have('weatherPaper')
            end,

            'Да принес вот держите.',
            function()
                p 'Хмм.. посмотрим.';

                if _'weatherPaper'.place == 'Барнаул' and _'weatherPaper'.src == 'Yandex' then
                    p 'Хорошо, то что надо, спасибо!'
                    needWeather = false;
                    achievs.weather = true;
                    updateStat(achievs);
                elseif _'weatherPaper'.place == 'Новосибирск' then
                    p 'Предлагаешь поехать в Новосибирск на выходные?';
                elseif _'weatherPaper'.src ~= 'Yandex' then
                    p 'Что-то я тут нифига не понимаю, распечатай нашу погоду из Яндекса и принеси мне!';
                end;
                
                if _'weatherPaper'.place ~= 'Барнаул' then
                    p 'Ты что, забыл в каком городе мы живем??';
                end;

                disable('weatherPaper');
                place('weatherPaper', 'hp_lj_1300')
                walkout();
            end
        },

        {
            'Нет пока, еще не успел распечатать...',
            'Ну давай быстрее!'
        }
    };
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
        only = true,
        
        {
            '#hello',
            'Здравствуйте!',
            'Здравствуй!'
        },
        {
            only = true,
            
            cond = function()
                return not achievs.eat;
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
        },
        
        {
            cond = function()
                return achievs.eat
            end,
            
            'Спасибо, было вкусно!',
            'На доброе здоровье!'
        }
    };

};