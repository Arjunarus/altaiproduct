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
            rndSelector {
                'Я проверил сообщения в контакте.',
                'Я добавил новых друзей.',
                'Я написал письмо подружке.',
                'Меня отметили на новых фотографиях.',
                'Прочитал новое сообщение на стене.',
                'Мою фотографию прокоментировали.'
            }
        },

        {always = true, 'livejournal.com', 'В ЖЖ ничего нового.'},

        {
            always = true,

            'google.com',
            function()
                if triggers.weather and disabled('weatherPaper') then
                    _'screen'.src = 'Google'
                    push('#weather')
                else
                    return rndItem {
                        'Я зашел в гугл.',
                        'Ну и чего будем искать?',
                        'Надо ввести запрос. Хм..',
                        'Погоду лучше смотреть в яндексе.',
                        'Слово "погуглить" я узнаю намного позже.'
                    }
                end
            end,
        },
        {
            always = true,
            'yandex.ru',

            function()
                if triggers.weather and disabled('weatherPaper') then
                    _'screen'.src = 'Yandex'
                    push('#weather')
                else
                    return rndItem {
                        'Я зашел в яндекс.',
                        'Что-то я забыл чего хотел найти...',
                        'Можно было бы скачать яндекс-браузер, но его еще не выпустили..'
                    }
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
                    _'screen'.place = 'Россия'
                    push('#actions')
                end
            },

            {
                always = true,
                'Погода в Москве.',
                function()
                    _'screen'.place = 'Москва'
                    push('#actions')
                end
            },

            {
                always = true,
                'Погода в Новосибирске.',
                function()
                    _'screen'.place = 'Новосибирск'
                    push('#actions')
                end
            },

            {
                always = true,
                'Погода в Барнауле.',
                function()
                    _'screen'.place = 'Барнаул'
                    push('#actions')
                end
            },

            {always = true, 'Назад', pfn(pop)}
        },

        {
            '#actions',
            hidden = true,

            {
                always = true,
                'Посмотреть',
                function()
                    if _'screen'.place == 'Барнаул' then
                        p 'Я смотрю погоду, хмм... завтра будет тепло, можно будет погулять с Катей после работы.'
                    else
                        return rndItem {
                            'Не знаю зачем мне смотреть погоду хрен пойми где.. ну да ладно.',
                            'Я посмотрел погоду.',
                            'Вроде обещают тепло.',
                            'Через 2 дня будет дождь.',
                            'Переменная облачность, без осадков.'
                        }
                    end
                end
            },

            {
                'Распечатать',
                function()
                    p 'Я пускаю погоду на печать.'
                    _'weatherPaper'.src = _'screen'.src
                    _'weatherPaper'.place = _'screen'.place
                    enable('weatherPaper')
                    walkout()
                end
            },

            {always = true, 'Назад', pfn(pop)}
        }
    };

    way = {'wplace'};
}