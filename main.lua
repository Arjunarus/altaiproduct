-- $Name: Приключения эникейщика в ООО "Молоко"$
-- $Version: 0.2$
-- $Author: ArjunaRus - http://vk.com/arjunarus $

instead_version "1.9.1"
require "para"
require "dash"
require "quotes"
require "nouse"
require "hideinv"

require "dbg"

--game.forcedsc = true;
game.codepage = "UTF-8";

game.act = 'Ничего не происходит';
game.inv = function(s,w)
    local r = rnd(6);
    local mes={
    [1]='Интересная штуковина..',
    [2]='Хм..',
    [3]='Как вы думаете, что это?',
    [4]='Симпатичная вещица, не так ли?',
    [5]='Забавная штука.',
    [6]='Куда бы это применить?',
    };
    return mes[r];
end;
game.nouse = function(s,w)
    local r = rnd(6);
    local mes={
    [1]='Не применяется...',
    [2]='Не пойму как это тут применить..',
    [3]='Ну и причем тут '..ref(w).nam..'?',
    [4]='Не срабатывает.',
    [5]='Ну и что к чему?',
    [6]='Да вы что, это же '..ref(w).nam..'!',
    };
    return mes[r];
end;

global {
    _needWeather = false;
    _dirtyHands = true;
}

--function init()
--end;

rndItem = function(table)
    return table[rnd(#table)];
end;

-- =============================================================================================

main = room {
    enter = function(s, f)
        if f ~= 'screen' then return 'Я сел на свое рабочее место.'; end;
    end;
    
    exit = function(s,f)
            if f == 'cab6' then return 'Я встал из-за компа.'; end;
    end;
    
    nam = 'Рабочее место';
    dsc = 'Я нахожусь в кабинете №6 за компом.';
    obj = {vway('монитор', 'На столе стоит {монитор}.', 'screen'), 'box'};
    way = {'cab6'};
};

box = obj {
    _opened = false;
    
    nam = 'Ящик стола';
    dsc = function (s)
            p "Выдвижной {ящик} в столе";
            if s._opened then 
                p "открыт.";
                if #objs(s) ~= 0 then p "В ящике лежит " end;
            else 
                p "закрыт.";
            end;
    end;
    act = function (s) 
            s._opened = not s._opened;
            if s._opened then 
                s:enable_all();
                return 'Я открыл ящик.';
            else 
                s:disable_all();
                return 'Я закрыл ящик.';
            end;
    end;
    obj =  {'turn_screw','thermal_compound','lubricant'}; 
};

turn_screw = obj {
    nam = 'отвертка';
    dsc = '{отвертка}';
    tak = 'Я взял отвертку.';
    inv = 'Обычная крестовая отвертка, универсальная :)';
} :disable();

thermal_compound = obj{
    nam = 'термопаста';
    dsc = '{термопаста}';
    tak = 'Я взял термопасту.';
    inv = 'Термопаста обеспечивает хорошую теплопроводность между процессором и радиатором.';
} :disable();

lubricant = obj {
    nam = 'смазка';
    dsc = '{смазка}';
    tak = 'Я взял смазку.';
    inv = 'Это смазка, чтобы кулеры не гудели (а не то, что вы подумали).';
} :disable();

screen = dlg {
    entered = 'На экране запущен браузер. Я вижу перед собой несколько быстрых ссылок.';
    nam = 'Экран';
    hideinv = true;
    
    phr = {
        {always = true, 'vkontakte.ru', code = [[return rndItem({'Я проверил сообщения в контакте.',
                                                                 'Я добавил новых друзей.', 
                                                                 'Я написал письмо подружке.',
                                                                 'Меня отметили на новых фотографиях.',
                                                                 'Прочитал новое сообщение на стене.',
                                                                 'Мою фотографию прокоментировали.'})]]};
        {always = true, 'livejournal.com', 'В ЖЖ ничего нового.'};
        {always = true, 'google.com', code = [[if _needWeather then
                                                   psub 'weather';
                                               else 
                                                   return rndItem({'Я зашел в гугл.', 
                                                                   'Ну и чего будем искать?', 
                                                                   'Надо ввести запрос.',
                                                                   'Погоду лучше смотреть в яндексе.'})]]};
        {always = true, 'yandex.ru', code = [[if _needWeather then 
                                                  psub 'weather';
                                              else 
                                                  return rndItem({'Я зашел в яндекс.',
                                                                  'Что-то я забыл чего хотел найти...',
                                                                  'Можно было бы скачать яндекс-браузер, но его еще не выпустили..'})
                                              end]]};
        {};
        {tag = 'weather', "Я ввожу в строке поиска ПОГОДА... На экране появляется несколько ссылок."};
        {'Погода в России. Распечатать','Я пускаю погоду на печать.'};
        {'Погода в Москве. Распечатать','Я пускаю погоду на печать.'};
        {'Погода в Барнауле. Распечатать','Я пускаю погоду на печать.', [[_needWeather = false]]};
        {always = true, 'Назад', code = [[pret()]]}
    };
    
--  obj = {
--      [3]=phr(,'',[[pon(3);weatherpaper._fromgoogle=true;return seeweather()]]),
--      [4]=phr('yandex.ru','',[[pon(4);return seeweather()]]),
--  },
    way = {'main'};
};

cab6 = room {
    enter = function()
--      lifeon('cophumlife');
        return 'Я в кабинете № 6.';
    end;
    exit = function()
--      lifeoff('cophumlife');
        return;
    end;
    nam = 'Кабинет №6';
    dsc = 'Это мой кабинет, но кроме меня тут еще сидят бухи и главбух.';
--  obj = {'tabl','mfu1','hp1300','copyhuman','cophumlife'},
    way = {'lobby_end','main'};
};

lobby_end = room {
    enter = function(s,f)
        if f == lobby_middle then 
            return 'Я перешел в конец коридора.';
        else 
            return 'Я вышел в коридор.';
        end;
    end;
    nam = 'Конец коридора';
    dsc = 'Это самый конец коридора.';
    way={'cab8','cab7','cab6','lobby_middle'};
};

lobby_middle = room {
    enter = function(s,f)
        if f == lobby_end or f == lobby_start then
            return 'Я прошел вдоль по коридору.';
        else 
            return 'Я вышел в коридор.';
        end;
    end;
    nam = 'Середина коридора';
    dsc = 'Я стою посреди коридора, передо мной множество дверей.';
    way={'cab5','cab4','cab3','cab2','lobby_end','lobby_start'};
};

lobby_start = room {
    enter = function(s,f)
        if f == lobby_middle then 
            return 'Я перешел в начало коридора.';
        elseif f == vihod then 
            return 'Я вошел в коридор нашей фирмы.';
        else 
            return 'Я вышел в коридор.';
        end;
    end,
    nam = 'Начало коридора';
    dsc = 'Тут начинается коридор и видно несколько дверей';
    way={'cab1','vihod','lobby_middle','wc1','wc2','archiveroom'};
};

serv = room {
    enter = 'Я вошел в серверную, тут довольно тесно.';
    nam = 'Серверная';
    dsc = [[То ли серверная, то ли кладовка, здесь полно всякого хлама.]];
    obj = {
        obj {
            nam = 'Сервер';
            dsc = 'На подставке стоит {сервер}.^';
            act = 'Сервер без монитора, так что ничего интересного я тут не увижу.';
        };
        obj {
            nam = 'Шлюз';
            dsc = 'На сервере сверху стоит еще один {системник} - это наш шлюз в интернет.^';
            act = 'Старенький системник с Linux-ом, обеспечивает безопасный доступ в инет и больше ничего.';
        };
        obj {
            nam = 'МиниАТС';
            dsc = 'На стене висит {мини АТС} фирмы Panasonic, к ней подходит куча проводов.^';
            act = 'Мини-АТС, сюда подходят провода от всех аппаратов фирмы, а также 3 городские линии.';
        };
        obj {
            nam = 'Свитчи';
            dsc = 'Еще на стене висят {два свитча} D-Link, тоже с кучей проводов.^';
            act = 'Свитчи тоже лучше не трогать, пока все работает.';
        };
        obj {
            nam = 'Автомат';
            dsc = 'Неподалеку от свитчей, тоже на стене прикреплены {автоматы} электропитания.^';
            act = function(s) 
                return rndItem({'Можно конечно поотрубать свет в каких-то отделах, но боюсь меня за это не похвалят.',
                                'Таки напросимся на неприятности, со своими шуточками.',
                                'Можно потестить методом тыка, за какой отдел какой автомат отвечает...'});
            end;
        };
        obj {
            nam = 'Отопление';
            dsc = 'На другой стене висит большой и страшный {агрегат} - это система автономного отоплления.^';
            act = function(s) 
                return rndItem ({'Лучше не трогать этот страшный девайс.', 
                            'А что, может отопление отключим? Гыыы ))', 
                            'Все равно сейчас не отопительный сезон.'});
            end;
        };
    };
    way={'cab8'};
};

cab8 = room {
    enter = 'Я вошел в кабинет № 8';
    nam = 'Кабинет №8';
    way={'lobby_end','serv'};
    obj = {
        obj {
            nam = 'бухи';
            dsc = 'Тут сидят обычные рядовые {бухи}.';
            act = 'И о чем поговорить с бухами, о дебетах и кредитах? Не интересно.'
        };
        vway('дверь','и находится {дверь} в серверную', 'serv');
    };
};

cab7 = room {
    enter = 'Я вошел в кабинет № 7';
    nam = 'Кабинет №7';
    dsc = 'Тут заседают логисты, и еще тут часто рубятся в ирушки';
    way = {'lobby_end'};
};

cab5 = room {
    enter = 'Я вошел в кабинет № 5';
    nam = 'Кабинет №5';
    dsc = 'Тут работает наш кассир, и еще иногда выдают зарплату, но не сегодня';
    way = {'lobby_middle'};
};

cab4 = room {
    enter = 'Я вошел в кабинет № 4';
    nam='Кабинет №4';
    dsc = 'Это самый главный кабинет.';
    
    used = function(s,w1,w2)
        if w1=='МФУ' and w2=='sheetpaper' then
            if game._MFUvoid then 
                return 'Копию снять нельзя, т.к. закончился тонер.';
            else 
                return 'Диспетчера что-то копируют на ксероксе, думаю я не скоро дождусь, пока он освободится.';
            end;
        end;
        return w;
    end;
    
    way = {'lobby_middle'},
    obj = {
        obj {
            nam = 'диспетчера';
            dsc = 'Тут трудятся {диспетчера}!';
            act = function()
                p 'Диспетчера "вежливо" попросили не мешать работать, лучше их не злить.';
                back();
            end;
        };
        obj {
            nam = 'МФУ';
            dsc = 'Посреди кабинета у стены стоит здоровое {МФУ}.';
            act = function(s)
                    if game._MFUvoid then 
                        return 'Закончился тонер. Теперь на нем копию не снимешь, пока не привезут новый тонер.';
                    else 
                        return 'МФУ Kyocera TaskAlfa 180 формата А3, японская как видно из названия )';
                    end;
            end;
        };
    },
};

cab3 = room {
    enter = 'Я вошел в кабинет № 3.',
    nam = 'Кабинет №3',
    dsc = 'Кабинет колбасного отдела.',
    way = {'lobby_middle'};
};

cab2 = room {
    enter = 'Я вошел в кабинет № 2.',
    nam='Кабинет №2',
    dsc = 'Кабинет директора, тоже очень главный!! отсюда часто доносятся громкие крики...',
    way = {'lobby_middle'};
};

cab1 = room {
    enter = 'Я вошел в первый кабинет.';
    nam = 'Кабинет №1';
    dsc = 'Это торговый отдел, тут сидят супервайзеры.',
    obj = {
        obj {
            nam = 'Cупервайзеры';
            dsc = 'Я сперва не представлял что это за {супервайзеры} такие и чего они "супервайзят", но потом понял.';
            act = [[Так вот, под каждым супервайзером ходит команда торговых представителей, 
                    а они их "супервайзят" чтобы продукция продавалась и вообще все ОК было, во как!]];
        };
    };
    way = {'lobby_start'};
};

wc1 = room {
    enter = 'Я пришел в туалет';
    nam = 'Туалет 1';
    dsc = 'Это обычный туалет';
    exit = function()
        if not wckey._opened then 
            return 'Я не могу выйти, ведь дверь закрыта', false;
        end;
    end;
    obj = {'pan','wckey','sink'};
    way = {'lobby_start'};
};

wc2 = room {
    enter = 'Я пришел в туалет';
    nam = 'Туалет 2';
    dsc = 'Это обычный туалет';
    exit = function()
        if not wckey._opened then 
            return 'Я не могу выйти, ведь дверь закрыта', false;
        end;
    end;
    obj = {'pan','wckey','sink'};
    way = {'lobby_start'};
};

sink = obj {
    nam = 'раковина',
    dsc = 'Сбоку на стене приделана {раковина} с кранами.',
    act = function()
        if _dirtyHands then
            _dirtyHands = false;
            return 'Я вымыл руки.';
        else 
            return 'Руки еще не замарались, зачем их так часто мыть?';
        end;
        
    end,
};

wckey = obj {
    _opened = true;
    nam = 'ключ';
    dsc = function(s)
        p 'В двери вставлен {ключ}. Дверь';
        if s._opened then 
            p 'открыта.';
        else
            p 'закрыта.';
        end;
    end,
    act = function(s)
        s._opened = not s._opened;
        return 'Я поворачиваю ключ.';
    end;
};

pan = obj {
    nam = 'унитаз',
    dsc = 'В конце туалета как и положено расположен {унитаз}.',
    act = function()
        if wckey._opened then 
            return 'А вдруг кто-нибудь зайдет и увидит?';
        else 
            return 'Вообще-то, я пока не хочу в туалет';
        end;
    end;
};

archiveroom = room {
    enter = 'Я зашел в архивную комнату';
    nam = 'Архивная';
    dsc = function() 
        p 'Эта комната что-то вроде большой кладовки. Здесь ночами сидят сторожа';
        p(txtst 'и смотрят порнуху.');
    end;
    obj = {
        obj {
            nam = 'телевизор';
            dsc = 'В углу стоит {телевизор}, чтобы сторожам не было скучно.';
            act = function()
                return rndItem({'Лучше я не буду сейчас включать телевизор.',
                                'Телевизор лучше не включать в рабочее время, если я не хочу работать сторожем.',
                                'Врядли там показывают что-то интересное, и вообще от телевизора тупеют!',
                                'Тот кто смотрит телевизор - заканчивает свою карьеру сторожем :)'});
            end;
        };
        obj {
            nam = 'коробки';
            dsc = 'Вдоль стен навалена куча {коробок}.';
            act = 'Коробки с документами, а также пустые коробки от тубы для Kyocera TaskAlfa 180';
        };
    };
    way = {'lobby_start','kitchen'},
};

kitchen = room {
    enter = 'Я пришел на кухню.';
    nam = 'Кухня';
    dsc = 'Это кухня, тут мы едим';
    obj = {
        vway('Повар', 'На кухне хозяйничает наш повар {Елена Ивановна}.', 'cookerDlg');
        'vegaFood',
        obj {
			nam = 'еда';
			dsc = function()
				if disabled(vegaFood) then 
					p 'На столе стоит вкусный {борщ} с капусткой, но не красный, {сосисочки}.';
				end;
			end;
			act = function()
					return rndItem({'Я уже 5 лет как вегетарианец злой, с каждой ЗП я покупаю курицу и отпускаю ее на волю!',
									'Не ем я такое, нельзя мне.',
									"I just don't eat meat",
									'Я просто не ем мясо - это нормально..',
									'Некоторые люди почему-то не едят мясо, так вот, я как раз один из них )'});
			end;
        };
    };
    way = {'archiveroom'},
};

vegaFood = obj{
    nam = 'вега-еда',
    dsc = [[Она поставила на стол {борщ} с капусткой но без мяса, 
            какой-то {салат} (куда крошат морковку, капусту и яблоки с ... ой увлекся...),
            вкусный {чай}. Я чувствую себя человеком!]];
    act = function(s)
        if not _dirtyHands then
            s:disable();
            cookerDlg:pon('thx');
            cookerDlg:pon('query');
            return 'Я поел, теперь можно спокойно работать дальше';
        else 
			return 'Я же не буду есть с грязными руками, так и заболеть можно!';
        end;
    end,
}:disable();

cookerDlg = dlg {
    hideinv = true;
    nam = 'Разговор с поваром';
    dsc = 'Я подошел к нашему повару - не молодая женщина в переднике и косынке.';
    phr = {
        {always = true, 'Здравствуйте!', 'Здравствуй!', [[back()]]};
        {	tag = 'query', 
			true, 
			'А нельзя ли что-нибудь съесть?', 
			'Да, конечно, там на столе - это тебе. Приятного аппетита.', 
			[[if disabled(vegaFood) then 
					pon('vegan'); 
			  end;]]
		};
        {tag = 'vegan', false, 'Но я же не ем мясное!', 'Ой, прости, сейчас чтонибудь придумаем...', [[vegaFood:enable(); back();]]};
        {tag = 'thx', false, 'Спасибо!', 'На доброе здоровье!', [[back();]]};
    };
    exit = 'Повар что-то делает.';
};

vihod = room{
    enter = function(s,f)
        if f == 'street' then 
            return 'Я вошел в здание';
        else 
            return 'Я вышел в подъезд';
        end;
    end;
    nam = 'Подъезд';
    dsc = 'Это можно назвать подъездом, тут ничего интересного';
    way={'lobby_start','street'};
};

street = room{
    nam = 'Улица',
    dsc = 'Я вышел на улицу',
    way = {'vihod'},
};
