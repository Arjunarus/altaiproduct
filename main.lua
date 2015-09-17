-- $Name: Приключения эникейщика в ООО "Молоко"$
-- $Version: 0.2$
-- $Author: ArjunaRus - http://vk.com/arjunarus $
--[[
    Эта история приключилась со мной, когда я работал на должности 'эникейщика' 
    в одной барнаульской фирме, название которой особого значения не имеет. 
    Это было в период 2009 -- 2010 гг. Сейчас этой фирмы уже нет. 
    Занималась она дистрибуцией продуктов питания, 
    преимущественно молочной продукции ВБД. 
    Периодически на фирме происходил пиздец разной степени тяжести,
    да и вообще работа там напоминала один большой пиздец, хотя справедливости ради,
    стоит отметить - были и спокойные деньки )
    Один рабочий день мне особо запомнился, он как раз и послужил сюжетом для данной 
    игры. Игра основана на реальных автобиографических событиях.
    
    Желаю приятного квеста!   
]]

instead_version "1.9.1"
require "para"
require "dash"
require "quotes"
require "nouse"
require "hideinv"

require "dbg"

--game.forcedsc = true;
game.codepage = "UTF-8";

rndItem = function(table)
    return table[rnd(#table)];
end;

game.act = 'Ничего не происходит';

game.inv = function(s,w)
            return rndItem({'Интересная штуковина..',
                            'Хм..',
                            'Как вы думаете, что это?',
                            'Симпатичная вещица, не так ли?',
                            'Забавная штука.',
                            'Куда бы это применить?' });
end;

game.nouse = function(s,w)
                return rndItem({'По-моему это сейчас не актуально',
                                'Не пойму как это тут применить..',
                                'Ну и причем тут ' .. w.nam .. '?',
                                'Не срабатывает.',
                                'Наркоман штоле? XD',
                                'Да вы что, это же ' .. w.nam .. '!',
                                'Можно конечно ' .. w.verb .. ', хм... думаешь поможет?',
                                'Ну конечно, если все ' .. w.verb .. ', то сразу всем всё понятно станет XD'
                                });
end;

achivs = stat {
    _value = 0;
    nam = 'достижения';
    disp = function(s) 
        return 'Достижения: ' .. s._value .. "^";
    end;
};

global {
    _needWeather = false;
    _dirtyHands = true;
}

function init()
    take(achivs);
    take(mobile);
end;

mobile = obj {
    verb = 'сфоткать на мобильник';
    
    nam = 'мобильник';
    inv = 'Это мой мобильник Motorolla C650, старенький, такие сейчас не в моде.';
    
};

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
    obj = {vway('монитор', 'На столе стоит {монитор}.', 'screen'),
           'box'
    };
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
    verb = 'раскрутить';

    nam = 'отвертка';
    dsc = '{отвертка}';
    tak = 'Я взял отвертку.';
    inv = 'Обычная крестовая отвертка, универсальная :)';
} :disable();

thermal_compound = obj {
    verb = 'намазать термопастой';
    
    nam = 'термопаста';
    dsc = '{термопаста}';
    tak = 'Я взял термопасту.';
    inv = 'Термопаста обеспечивает хорошую теплопроводность между процессором и радиатором.';
} :disable();

lubricant = obj {
    verb = 'смазать';

    nam = 'смазка';
    dsc = '{смазка}';
    tak = 'Я взял смазку.';
    inv = 'Это смазка, чтобы кулеры не гудели (а не то, что вы подумали).';
} :disable();

screen = dlg {
    dsc = 'На экране запущен браузер. Я вижу перед собой несколько быстрых ссылок.';
    nam = 'Экран';
    hideinv = true;
    _src = nil;

    phr = {
        {always = true, 'vkontakte.ru', code = [[return rndItem({'Я проверил сообщения в контакте.',
                                                                 'Я добавил новых друзей.',
                                                                 'Я написал письмо подружке.',
                                                                 'Меня отметили на новых фотографиях.',
                                                                 'Прочитал новое сообщение на стене.',
                                                                 'Мою фотографию прокоментировали.'})]]};
        {always = true, 'livejournal.com', 'В ЖЖ ничего нового.'};
        {always = true, 'google.com', code = [[if _needWeather then
                                                   screen._src = 'Google'; 
                                                   psub 'weather';
                                               else
                                                   return rndItem({'Я зашел в гугл.',
                                                                   'Ну и чего будем искать?',
                                                                   'Надо ввести запрос. Хм..',
                                                                   'Погоду лучше смотреть в яндексе.'})
                                               end]]};
        {always = true, 'yandex.ru', code = [[if _needWeather then
                                                  psub 'weather';
                                                  screen._src = 'Yandex';
                                              else
                                                  return rndItem({'Я зашел в яндекс.',
                                                                  'Что-то я забыл чего хотел найти...',
                                                                  'Можно было бы скачать яндекс-браузер, но его еще не выпустили..'})
                                              end]]};
        {};
        {tag = 'weather', "Я ввожу в строке поиска ПОГОДА... На экране появляется несколько ссылок."};
        {'Погода в России. Распечатать','Я пускаю погоду на печать.', [[putWeather(screen._src, 'Россия'); pret()]]};
        {'Погода в Москве. Распечатать','Я пускаю погоду на печать.', [[putWeather(screen._src, 'Москва'); pret()]]};
        {'Погода в Барнауле. Распечатать','Я пускаю погоду на печать.', [[putWeather(screen._src, 'Барнаул'); pret()]]};
        {always = true, 'Назад', code = [[pret()]]}
    };
    
    way = {'main'};
};

weatherPaper = obj {
    _src = nil;
    _place = nil;
    verb = 'завернуть';

    nam = 'распечатка погоды';
    dsc = 'В принтере лежит {распечатка погоды}.';
    act = 'Это распечатка погоды, директор попросил.';
    tak = 'Я взял распечатку погоды.';
    inv = 'Прогноз погоды на ближайшие дни.';
};

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

--======================================================================

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
    obj = {
        vway('Стол', 'В кабинете стоит мой {стол} с компьютером.', 'main');
        'mfp1',
        obj {
            nam = 'Принтер';
            dsc = 'Около главбуха стоит {принтер}.';
            act = 'Принтер HP LJ 1300, старенький но работает';
        };
    };
    way = {'lobby_end','main'};
};

isMfp1Jammed = function()
    return (exist(jammedPaper, mfpInside) ~= nil);
end;

mfp1 = obj { 
    nam = 'Sharp AL-1217';
    dsc = 'Рядом со столом стоит старое {МФУ Sharp}.';
    used = function(s, w)
        if w == someDocument then
            p('Я поместил ' .. w.nam .. ' внутрь МФУ на стекло сканера.');
            placef(w, s);
            inv():del(w);
        else
            p(rndItem({w.verb .. 'МФУ? Хм... ну не знаю, не знаю...',
                        'Можно конечно ' .. w.verb .. 'МФУ, но непонятно что делать потом..'}));
        end;
        return true;
    end;
    act = function(s)
        if isMfp1Jammed() and disabled(mfpInside) then
            enable(mfpInside);
            return 'Осмотрев МФУ, сбоку я обнаружил крышку.';
        elseif (objs(s):srch(someDocument) ~= nil) then
            walkin('mfuPanel');
            return;
        else
            return 'Старая МФУ-шка, уже снятая с производства, модель Sharp AL-1217.';
        end;
    end;
    obj = {'mfpInside'};
};

mfpInside = obj {
    _opened = false;
    _fixed = false;
    
    nam = 'mfpInside';
    dsc = function(s)
        if s._opened then
            return '{Крышка} МФУ открыта.';
        else
            return '{Крышка} МФУ закрыта.';
        end;
    end;
    act = function(s)
        if s._opened then
            s._opened = false;
            return 'Я захлопнул крышку';
        else
            return 'Крышка закрыта';
        end;
    end;
    obj = {
        obj {
            nam = 'lock';
            dsc = function(s)
                if not mfpInside._opened then
                    return 'Она защелкивается на {защелку}.';
                end;
            end;
            act = function(s)
                mfpInside._opened = true;
                return 'Я нажал на защелку, крышка открылась.';
            end;
        };
        
        obj {
            nam = 'screw';
            dsc = function(s)
                if mfpInside._opened then
                    return '^Внутри МФУ выделяется один {болт}, который держит механизм.';
                end;
            end;
            act = function(s)
                if mfpInside._fixed then
                    return 'Отрегулированный болт, может быть теперь бумага не будет зажевываться.';
                else 
                    return 'Болт держит механизм прохода бумаги. Его бы подрегулировать..';
                end;
            end;
            used = function(s, w)
                if w == turn_screw then
                    if (mfpInside._fixed) then
                        return 'Я уже отрегулировал болт, лучше к нему теперь не лезть.';
                    end;
                    
                    mfpInside._fixed = true;
                    return 'Я подрегулировал болт, кажется теперь не должно зажевывать.';
                else 
                    return 'Предлагаете ' .. w.verb .. ' болт? Мдя... его надо подрегулировать, а не ' .. w.verb .. '!';
                end;
            end;
        };
    };
    
}:disable();

jammedPaper = obj {
    nam = 'jammedPaper';
    dsc = function(s)
        if mfpInside._opened then
            return '^В механизме виден смятый {лист бумаги}.';
        end;
    end;
    act = function(s)
        remove(s, mfpInside);
        return 'Я вытащил помятый лист из механизма';
    end;
};

-- TODO: change this dialog to room, because too much code inside strings
mfuPanel = dlg {
    _copyMode = false;
    hideinv = true;
    
    nam = 'Ксерокопирование';
    dsc = 'На лицевой панели МФУ располагаются органы управления';
	phr = {
		{always = true, 'Кнопка переключения режима.', 'Режим работы:', 
        [[
            _copyMode = not _copyMode; 
            if _copyMode then
                p 'копирование';
            else
                p 'сканирование'
            end;
        ]]};
		{always = true, 'Кнопка копирования.', 'Я нажал кнопку копирования...^', 
        [[
            if not _copyMode then
                p 'МФУ стоит в режиме сканирования. В этом режиме копии не снимаются.';
            elseif mfpInside._opened then
                p 'Крышка МФУ открыта, в этом состоянии он не будет работать';
            elseif  isMfp1Jammed() then
                p 'Кажется внутри зажевана бумага, сначала надо ее вытащить.';
            elseif not mfpInside._fixed then
                place(jammedPaper, mfpInside);
                p 'Ну вот, МФУ зажевал бумагу. Он очень старый я ведь предупреждал!';
                back();
            else
                objs(mfp1):del(someDocument);
                achivs._value = achivs._value + 1;
                p 'Ну все, кажется копия успешно снялась, УРА!';
                back();
            end;
        ]]};
		{always = true, 'Кнопки настройки изображения.', 'Я настроил изображение получше. Хотя, вроде, и так было норм.'};
	};
    
    way = {'cab6'};
};

someDocument = obj {
    verb = 'завернуть';
    
	nam = 'какой-то документ';
	inv = 'Этот документ мне дали чтобы снять с него копию.';
    dsc = 'В сканере МФУ находится {какой-то документ}.';
    tak = 'Я вытащил документ из сканера.';
};

--======================================================================

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
        elseif f == porch then
            return 'Я вошел в коридор нашей фирмы.';
        else
            return 'Я вышел в коридор.';
        end;
    end,
    nam = 'Начало коридора';
    dsc = 'Тут начинается коридор и видно несколько дверей';
    way={'cab1','porch','lobby_middle','wc1','wc2','archiveroom'};
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
    nam = 'Кабинет №4';
    dsc = 'Это самый главный кабинет.';

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
            act = 'МФУ Kyocera TaskAlfa 180 формата А3, японская как видно из названия )';
            used = function(s, w)
                if w == someDocument then
                    p 'Тонер закончился, так что снять копию не получится.';
                else
                    p(rndItem({w.verb .. 'МФУ? Хм... ну не знаю, не знаю...',
                                'Можно конечно ' .. w.verb .. 'МФУ, можно еще и диспетчеров ' .. w.verb .. '.'}));
                end;
                return true;
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

-- =====================================================================

cab2 = room {
    enter = function(s, w)
        if have(weatherPaper) == nil then
            return 'Это кабинет директора, лучше туда не заходить просто так.', false;
        else
            return 'Я вошел в кабинет № 2.';
        end;
    end;
    nam = 'Кабинет №2';
    dsc = 'Кабинет директора, тоже очень главный!! отсюда часто доносятся громкие крики...';
    obj = {
        obj {
            nam = 'Директор';
            dsc = 'За крутым директорским столом, на крутом кресле отделаном кожей сидит наш {директор} -- Михалыч';
            act = 'Нужна веская причина чтобы отвлекать директора.';
            used = function(s, w)
                if w == weatherPaper then
                    walkin(weatherDlg);
                end;
            end;
        };
    };
    way = {'lobby_middle'};
};

weatherDlg = dlg {
    hideinv = true;
    
    nam = 'разговор с директором';
    dsc = 'Ну что принес погоду?';
    
    phr = {
        {'Да принес вот держите.', 'Хмм.. посмотрим', 
        [[
            if weatherPaper._place ~= 'Барнаул' then
                p 'Ты мне чью погоду то принес? Забыл в каком городе мы живем??';
                _needWeather = true;
            elseif weatherPaper._src ~= 'Yandex' then
                p 'Что-то я тут нифига не понимаю, распечатай погоду из Яндекса и принеси мне!';
                _needWeather = true;
            else
                p 'Хорошо, спасибо!'
                _needWeather = false;
                achivs._value = achivs._value + 1;
            end;
            remove(weatherPaper, me());
            back();
        ]]};
    };
};

-- =====================================================================

cab1 = room {
    enter = 'Я вошел в первый кабинет.';
    nam = 'Кабинет №1';
    dsc = 'Это торговый отдел, тут сидят супервайзеры.',
    obj = {
        obj {
            nam = 'Cупервайзеры';
            dsc = 'Я сперва не представлял что это за {супервайзеры} такие и чего они "супервайзят", но потом понял.';
            act = function()
                    return rndItem({[[Если интересно, то под каждым супервайзером ходит команда торговых представителей,
                                      а они их "супервайзят" чтобы продукция продавалась и вообще все ОК было, во как!]],
                                    [[С супервайзерами как и с бухами говорить особо не о чем, 
                                    но иногда они просят сочинить им очередную формулу в экселе.]]});
            end;
        };
    };
    way = {'lobby_start'};
};

-- =====================================================================

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

-- =====================================================================

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

-- =====================================================================

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

vegaFood = obj {
    nam = 'вега-еда',
    dsc = [[Она поставила на стол {борщ} с капусткой но без мяса,
            какой-то {салат} (куда крошат морковку, капусту и яблоки с ... ой увлекся...),
            вкусный {чай}. Я чувствую себя человеком!]];
    act = function(s)
        if not _dirtyHands then
            s:disable();
            cookerDlg:pon('thx');
            achivs._value = achivs._value + 1;
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
        {   tag = 'query',
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

-- =====================================================================

porch = room {
    enter = function(s,f)
        if f == 'street' then
            return 'Я вошел в здание';
        else
            return 'Я вышел в подъезд';
        end;
    end;
    nam = 'Подъезд';
    dsc = 'Это можно назвать подъездом, тут ничего интересного';
    obj = {
        vway('Ступеньки', 'Сбоку расположены {ступеньки}, ведущие наверх.', 'upstairsSquare');
    };
    way = {'lobby_start','street', 'upstairsSquare'};
};

upstairsSquare = room {
    nam = 'Второй этаж площадка';
    dsc = 'Я попал на лестничную площадку 2-го этажа.';
    obj = {
        vway('Дверь в коридор', 'Прямо передо мной {дверь} ведущая в помещения втрого этажа.', 'secondFloor');
        obj {
            nam = 'Лестница на крышу';
            dsc = '^Сбоку от меня находится {лестница} на крышу.';
            act = 'Выход на крышу закрыт, просто так туда не попасть.';
        };
        vway('Ступеньки', '^Позади меня {ступеньки}, ведущие вниз.', 'porch');
    };
    
    way = {'secondFloor', 'porch'};
};

secondFloor = room {
    nam = 'Второй этаж';
    dsc = 'Я в коридоре на втором этаже. Передо мной множество дверей.';
    obj = {vway('Кабинет Жанны', 'Одна {дверь}, я знаю точно, ведет в кабинет Жанны.', 'jannaRoom')};
    way = {'jannaRoom', 'upstairsSquare'};
};

jannaRoom = room {
    nam = 'Кабинет Жанны';
    dsc = 'Это кабинет Жанны, она наш партнер по бизнесу или что-то вроде того.';
    way = {'secondFloor'};
};

street = room {
    nam = 'Улица';
    dsc = 'Я вышел на улицу';
    way = {'porch'};
};
