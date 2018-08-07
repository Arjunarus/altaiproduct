require "noinv"

dlg {
    dsc = 'На экране запущен браузер. Я вижу перед собой несколько быстрых ссылок.';
    nam = 'screen';
    disp = 'Экран монитора';
    noinv = true;
    _src = nil;

    phr = {
        {
            true, 
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
            true, 
            'google.com', 
            function()
                if _needWeather then
                    screen._src = 'Google'; 
                    psub 'weather';
                else
                    return rndItem({
                        'Я зашел в гугл.',
                        'Ну и чего будем искать?',
                        'Надо ввести запрос. Хм..',
                        'Погоду лучше смотреть в яндексе.'
                    })
                end
            end
        },
        {
            true, 
            'yandex.ru', 
            function() 
                if _needWeather then
                    psub 'weather';
                    screen._src = 'Yandex';
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
        {tag = 'weather', "Я ввожу в строке поиска ПОГОДА... На экране появляется несколько ссылок."};
        {'Погода в России. Распечатать','Я пускаю погоду на печать.', [[putWeather(screen._src, 'Россия'); pret()]]};
        {'Погода в Москве. Распечатать','Я пускаю погоду на печать.', [[putWeather(screen._src, 'Москва'); pret()]]};
        {'Погода в Барнауле. Распечатать','Я пускаю погоду на печать.', [[putWeather(screen._src, 'Барнаул'); pret()]]};
        {always = true, 'Назад', code = [[pret()]]}
    };
    
    way = {'wplace'};
};
