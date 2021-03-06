room {
    nam = 'main';
    disp = 'Приключения эникейщика в ООО "Молоко"';
    dsc = [[
        Эта история приключилась со мной, когда я работал на должности 'эникейщика'
        в одной барнаульской фирме в период 2009 -- 2010 гг. Сейчас этой фирмы уже нет.
        Занималась она дистрибуцией продуктов питания, преимущественно молочной продукции ВБД.
        Периодически, на фирме происходил п***ц разной степени тяжести: то отопление прорвет,
        то электрики в проводке напутают ну и все в таком роде ))^
        Один рабочий день мне особо запомнился, он и послужил сюжетом для данной
        игры. Игра основана на реальных автобиографических событиях! ^^
    ]];

}:with {
    obj {
        dsc = '{Желаю приятного квеста!}';
        act = function()
            take('status');
            take('mobile');
            walk('wplace');
            lifeon();
            lifeon('mobile', 1);
        end;
    };
};

room {
    nam = 'wplace';
    disp = 'Рабочее место';
    dsc = [[Я нахожусь в кабинете №6 за своим рабочим местом.]];
    decor = function()
        p 'На столе стоит небольшой {монитор|монитор}.'
        if seen('landline_phone') then
            p 'Справа от меня стоит старый красный {landline_phone|телефон}.';
        end;
    end;

    enter = function(this, f)
        if f.nam == 'cab6' then
            return 'Я сел на свое рабочее место.';
        end;
    end;

    way = {
        path {'Встать из за стола', 'cab6'}
    };
    
    obj = {'landline_phone'};
    
}:with {
    obj {
        nam = 'монитор';
        disp = 'монитор';
        act = pfn(walkin, 'screen');
    };
};

room {
    nam = 'cab6';
    disp = 'Кабинет №6';
    dsc = [[Это мой рабочий кабинет, но кроме меня тут еще сидят бухи и главбух.]];
    decor = [[В кабинете стоит мой {стол|стол} с компьютером. Около главбуха стоит {hp_lj_1300|принтер}.
        Рядом со столом стоит старое {mfp_1|МФУ Sharp}.
    ]];

    enter = function(this, f)
        if f.nam == 'wplace' then
            return 'Я встал из-за стола.';
        end;
        
        -- Enable copy woman in 1 time from 5 entering
        if rnd(5) % 3 == 0 and not achievs.copy then
            enable('copyWoman');
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
        disp = 'МФУ';
        dsc = function(this)
            if lookup('someDocument', this) ~= nil then
                p('В сканере МФУ находится {someDocument|какой-то документ}.');
            end;
        end;

        act = function(this)
            if not disabled('jammedPaper') and disabled('mfpCover') then
                enable('mfpCover');
                return 'Осмотрев МФУ, сбоку я обнаружил крышку.';
            elseif lookup('someDocument', this) ~= nil then
                walkin('mfuPanel');
                return;
            else
                p [[Старая МФУ-шка, уже снятая с производства, модель Sharp AL-1217.]];
            end;
        end;

        used = function(this, w)
            if w.nam == 'someDocument' then
                p('Я поместил ' .. w.disp .. ' внутрь МФУ на стекло сканера.');
                place(w, this);
            else
                p(rndItem({
                    'Хотите ' .. w.verb .. ' МФУ? Хм... ну не знаю, не знаю...',
                    'Можно конечно ' .. w.verb .. ' МФУ, но непонятно что делать потом..'
                }));
            end;
        end;

    }:with {
        obj {
            nam = '#lock';
            disp = 'защелка';

            act = function(this)
                p 'Я нажал на защелку, крышка открылась.';
                _'mfpCover'.opened = true;
            end;
        };

        obj {
            nam = 'mfpCover';
            fixed = false;
            opened = false;

            -- TODO
            dsc = function(this)
                if this.opened then
                    return '{Крышка} МФУ открыта. Внутри МФУ выделяется один {screw|болт}, который держит механизм.';
                else
                    return '{Крышка} МФУ закрыта. Она защелкивается на {#lock|защелку}.';
                end;
            end;

            act = function(this)
                if this.opened then
                    this.opened = false;
                    return 'Я захлопнул крышку';
                else
                    return 'Крышка закрыта.';
                end;
            end;
        }:disable();

        obj {
            nam = 'screw';
            disp = 'болт';

            act = function(this)
                if _'mfpCover'.fixed then
                    return 'Отрегулированный болт, может быть теперь бумага не будет зажевываться.';
                else
                    return 'Болт держит механизм прохода бумаги. Его бы подрегулировать..';
                end;
            end;

            used = function(this, w)
                if w.nam == 'turn_screw' then
                    if (_'mfpCover'.fixed) then
                        return 'Я уже отрегулировал болт, лучше к нему теперь не лезть.';
                    end;

                    _'mfpCover'.fixed = true;
                    return 'Я подрегулировал болт, кажется теперь не должно зажевывать.';
                else
                    p(rndItem({
                        'Предлагаете ' .. w.verb .. ' болт? Мдя... его надо подрегулировать, а не ' .. w.verb .. '!',
                        'Можно конечно ' .. w.verb .. ' болт, а что потом?'
                    }));
                end;
            end;
        };

        obj {
            nam = 'jammedPaper';
            disp = 'смятый лист';
            dsc = function(this)
                if _'mfpCover'.opened and not disabled('mfpCover') then
                    return 'В механизме виден смятый {лист бумаги}.';
                end;
            end;

            act = function(this)
                disable(this);
                return 'Я вытащил помятый лист из механизма';
            end;
        }:disable();
    };

    obj {
        nam = 'copyWoman',
        disp = 'сотрудница';
        dsc = function()
            if have('someDocument') or lookup('someDocument', 'mfp_1') ~= nil then
                p '^В кабинете находится {сотрудница}, которой нужна копия документа.';
            else
                p 'В кабинет пришла {сотрудница} кажется ей что-то от меня нужно.';
            end;
        end;
        
        act = function()
            walkin('copyDlg');
        end,

    }:disable();
    
    obj {
        nam = 'стол';
        disp = 'рабочий стол';
        act = pfn(walk, 'wplace');
        obj = {'box'};
    };

    obj {
        nam = 'hp_lj_1300';
        disp = 'принтер';
        act = function(this)
            p 'Принтер HP LJ 1300, старенький, но работает.';
            if where('weatherPaper').nam == 'hp_lj_1300' then
                p 'В принтере лежит {weatherPaper|распечатка погоды}.';
            end;
        end;
    }:with {
        obj {
            nam = 'weatherPaper';
            disp = 'распечатка погоды';
            
            src = '';
            place = '';
            verb = 'завернуть';

            
            act = 'Это распечатка погоды, директор попросил.';
            tak = 'Я взял распечатку погоды.';
            inv = 'Прогноз погоды на ближайшие дни.';
        }:disable();
    };
};

room {
    nam = 'lobby_end';
    disp = 'Конец коридора';
    dsc = [[Это самый конец коридора.]];

    enter = function(this,f)
        if f.name == 'lobby_middle' then
            return 'Я перешел в конец коридора.';
        else
            return 'Я вышел в коридор.';
        end;
    end;

    way = {
        'lobby_middle',
        'cab6',
        'cab7',
        'cab8'
    };
};

room {
    nam = 'cab7';
    disp = 'Кабинет №7';
    dsc = 'Тут заседают логисты, и еще тут часто рубятся в ирушки';
    decor = 'У логистов часто тусуется {petrovich|Петрович}.';
    enter = 'Я вошел в кабинет № 7';
    
    way = {'lobby_end'};
}:with {
    obj {
        nam = 'petrovich';
        act = function()
            if triggers.mainTask then
                walkin('petrDlg');
            else
                p 'Это наш завхоз Петрович.';
                p 'Петрович у нас отвечает за электрику, отопление ну и всё в таком духе.';
            end;
        end;
    };
};

room {
    nam = 'cab8';
    disp = 'Кабинет №8';
    decor = function()
        p 'Тут сидят обычные рядовые {бухи|бухи} и находится {#дверь|дверь} в серверную.';
        if seen('knife') then
                p 'На столе среди бумаг я заметил {knife|нож}.';
        end;
    end;

    enter = 'Я вошел в кабинет № 8.';

    way = {
        'serv',
        'lobby_end'
    };

    obj = {'knife'};
    
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
    decor = function ()
        p [[На подставке стоит {сервер|сервер}. На сервере сверху стоит еще один {шлюз|системник} - это наш шлюз в интернет.^
            На стене висит {МиниАТС|мини АТС} фирмы Panasonic, к ней подходит куча {#cords|проводов}.^
            Еще на стене висят {Свитчи|два свитча} D-Link, тоже с кучей проводов.^
            Неподалеку от свитчей, тоже на стене прикреплены {Автомат|автоматы} электропитания.^
            На другой стене висит большой и страшный {Отопление|агрегат} - это система автономного отоплления.
        ]];
        if not _'#slot':disabled() then
            p 'Один свободный {#slot|слот} - в него был подключен кабель от склада.'
        end;
    end;

    enter = 'Я вошел в серверную, тут довольно тесно.';
    
    obj = {'tape'};
    way = {'cab8'};
}:with {

    obj {
        nam = '#cords';
        act = function()
            if triggers.mainTask then
                if triggers.seenStockLine then
                    p 'Среди кучи одинаковых проводов я замечаю один {#stock_line|черный}, точно такой же я видел на складе.'
                else
                    p 'Если бы я знал какой из них отвечает за склад...'
                end;
            else
                p 'Сюда подключены телефонные линии со всех кабинетов.';
            end;
        end;
        
        obj = {
            obj {
                nam = '#slot';
                act = function()
                    
                end;
            }:disable();
        }
    };
    
    
    obj {
        nam = '#stock_line';
        act = function()
            p 'Я отсоединяю ';
        end;
    };
    
    obj {
        nam = 'сервер';
        act = 'Сервер без монитора, так что ничего интересного я тут не увижу.';
    };
    
    obj {
        nam = 'шлюз';
        act = function()
            p 'Старенький системник с Linux-ом, обеспечивает безопасный доступ в инет и больше ничего.';
            if seen('tape') then
                p 'Сверху на системнике я заметил {tape|изоленту}.';
            end;
        end;
    };
    
    obj {
        nam = 'МиниАТС';
        act = function()
            p 'Мини-АТС, сюда подключены все телефонные аппараты фирмы, а также 3 городские линии.';
            if triggers.mainTask then
                p 'Я вижу свободный конец {cable|кабеля}, который ни к чему не подключен.';
            end;
        end;
        
        obj = {'cable'};
    };
    
    obj {
        nam = 'Свитчи';
        act = 'Свитчи тоже лучше не трогать, пока все работает.';
    };
    
    obj {
        nam = 'Автомат';
        act = function(this)
            return rndItem({
                'Можно конечно поотрубать свет в каких-то отделах, но боюсь меня за это не похвалят.',
                'Таки напросимся на неприятности, со своими шуточками.',
                'Можно потестить методом тыка, за какой отдел какой автомат отвечает...'
            });
        end;
    };
    
    obj {
        nam = 'Отопление';
        act = function(this)
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

    enter = function(this,f)
        if f.nam == 'lobby_end' or f.nam == 'lobby_start' then
            return 'Я прошел вдоль по коридору.';
        else
            return 'Я вышел в коридор.';
        end;
    end;

    way = {
        'lobby_start',
        'cab2',
        'cab3',
        'cab4',
        'cab5',
        'lobby_end'
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
        used = function(this, w)
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
    decor = [[За крутым директорским столом, на крутом кожаном кресле сидит наш директор -- {principal|Михалыч}]];
    onexit = function()
        if achievs.weather and not triggers.mainTask then
            p 'Подожди не уходи! Есть еще кое что!';
            return false;
        end;
    end;
    
    onenter = function(this, w)
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
        nam = 'principal';
        disp = 'Директор';
        act = function()
            if achievs.weather and not triggers.mainTask then
                walkin('mainTaskDlg');
                triggers.mainTask = true;
            else
                p 'Нужна веская причина чтобы отвлекать директора.';
            end;
        end;
        
        used = function(this, w)
            if w.nam == 'weatherPaper' then
                walkin('weatherDlg');
            else
                return false;
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

    enter = function(this,f)
        if f.nam == 'lobby_middle' then
            return 'Я перешел в начало коридора.';
        elseif f.nam == 'porch' then
            return 'Я вошел в коридор нашей фирмы.';
        else
            return 'Я вышел в коридор.';
        end;
    end;

    way = {
        'porch',
        'wc1',
        'wc2',
        'archiveroom',
        'cab1',
        'lobby_middle'
    };
};

room {
    nam = 'cab1';
    disp = 'Кабинет №1';
    dsc = 'Это торговый отдел, тут сидят {Cупервайзеры|супервайзеры}.',
    decor = [[Я сперва не представлял, что это за {Cупервайзеры|супервайзеры} такие и чего они "супервайзят", но потом понял.]];
    enter = 'Я вошел в первый кабинет.';

    way = {'lobby_start'};
}:with {
    obj {
        nam = 'Cупервайзеры';
        act = function()
                return rndItem({
                    [[Если интересно, то под каждым супервайзером ходит команда торговых представителей,
                        а они их "супервайзят" чтобы продукция продавалась и вообще все ОК было, во как!]],
                    [[С супервайзерами как и с бухами говорить особо не о чем,
                        но иногда они просят сочинить им очередную формулу в экселе.]]
                });
        end;
    };
};

room {
    nam = 'archiveroom';
    disp = 'Архивная';

    dsc = 'Эта комната что-то вроде большой кладовки. Здесь ночами сидят сторожа' .. fmt.st(' и смотрят порнуху') .. '.';

    decor = [[В углу стоит {телевизор|телевизор}, чтобы сторожам не было скучно.
        Вдоль стен навалена куча {коробки|коробок}.
    ]];

    enter = 'Я зашел в архивную комнату';
    way = {
        'kitchen',
        'lobby_start',
    },
}:with {
    obj {
        nam = 'телевизор';
        act = function()
            return rndItem({
                'Лучше я не буду сейчас включать телевизор.',
                'Телевизор лучше не включать в рабочее время, если я не хочу работать сторожем.',
                'Врядли там показывают что-то интересное, и вообще от телевизора тупеют!',
                'Тот кто смотрит телевизор - работает сторожем :)'
            });
        end;
    };
    obj {
        nam = 'коробки';
        act = function()
            p 'Коробки с документами, а также пустые коробки от тубы для Kyocera TaskAlfa 180';
            if seen('handset') then
                p 'В одной из коробок я заметил оторванную телефонную {handset|трубку}.'
            end;
        end;
        obj = {'handset'};
    };
};

room {
    nam = 'kitchen';
    disp = 'Кухня';
    decor = function()
        p [[На кухне хозяйничает наш повар {повар|Елена Ивановна}.^]];

        if disabled('vegaFood') then
            p 'На столе стоит вкусный {еда|борщ} с капусткой, но не красный, {еда|сосисочки}.';
        else
            p 'Она поставила на стол {vegaFood|борщ} с капусткой но без мяса, какой-то {vegaFood|салат} ';
            p(fmt.st('(куда крошат морковку, капусту и яблоки с ананасами)'));
            p 'вкусный {vegaFood|чай}. Я чувствую себя человеком!';
        end;
    end;

    enter = 'Я пришел на кухню, тут мы едим';

    way = {'archiveroom'};
}:with {
    obj {
        nam = 'повар';
        act = pfn(walkin, 'cookerDlg');
    };

    obj {
        nam = 'vegaFood';

        act = function(this)
            if not triggers.dirtyHands then
                achievs.eat = true;
                triggers.wantToEat = false;
                updateStat(achievs);
                p 'Я поел, теперь можно спокойно работать дальше';
                disable('vegaFood');
            else
                p 'Я же не буду есть с грязными руками, так и заболеть можно!';
            end;
        end,
    }:disable();

    obj {
        nam = 'еда';
        act = function()
            if achievs.eat then
                p 'Я уже поел.';
            else
                return rndItem({
                    'Я уже 5 лет как вегетарианец злой, с каждой ЗП я покупаю курицу и отпускаю ее на волю!',
                    'Не ем я такое, нельзя мне.',
                    "I just don't eat meat",
                    'Я, просто, не ем мясо - это нормально..',
                    'Я вегетарианец, кстати, прекрасно себя чувствую! А вы нет? Это все из-за мяса! :)',
                    'Некоторые люди почему-то не едят мясо, так вот, я как раз один из них )'
                });
            end;
        end;
    };
};

room {
    nam = 'wc1';
    disp = 'Туалет 1';
    dsc = 'Это обычный туалет';
    decor = [[Сбоку на стене приделана {sink|раковина} с кранами.
        В конце туалета, как и положено, расположен {pan|унитаз}.
        В двери вставлен {#wckey|ключ}.
    ]];
    enter = 'Я пришел в туалет';

    onexit = function()
        if _'#wckey':closed() then
            p 'Я не могу выйти, дверь закрыта';
            return false;
        end;
    end;

    obj = {'sink', 'pan'};

    way = {'lobby_start'};
}:with {
    obj {
        nam = '#wckey';
        disp = 'ключ';

        dsc = function(this)
            if this:closed() then
                p 'Дверь закрыта.';
            else
                p 'Дверь открыта.';
            end;
        end;

        act = function(this)
            if this:closed() then
                this:open();
            else
                this:close()
            end;
            return 'Я поворачиваю ключ.';
        end;
    }:open();
};

room {
    nam = 'wc2';
    disp = 'Туалет 2';
    dsc = 'Это обычный туалет';
    decor = [[Сбоку на стене приделана {sink|раковина} с кранами.
        В конце туалета, как и положено, расположен {pan|унитаз}.
        В двери вставлен {#wckey|ключ}.
    ]];
    enter = 'Я пришел в туалет';

    onexit = function()
        if _'#wckey':closed() then
            p 'Я не могу выйти, дверь закрыта';
            return false;
        end;
    end;

    obj = {'sink', 'pan'};

    way = {'lobby_start'};
}:with {
    obj {
        nam = '#wckey';
        disp = 'ключ';

        dsc = function(this)
            if this:closed() then
                p 'Дверь закрыта.';
            else
                p 'Дверь открыта.';
            end;
        end;

        act = function(this)
            if this:closed() then
                this:open();
            else
                this:close()
            end;
            return 'Я поворачиваю ключ.';
        end;
    }:open();
};

room {
    nam = 'porch';
    disp = 'Подъезд';
    dsc = 'Это можно назвать подъездом, тут ничего интересного';
    decor = [[Слева расположены {#ступеньки|ступеньки}, ведущие наверх.]];

    enter = function(this,f)
        if f.nam == 'main_enter' then
            return 'Я вошел в здание';
        else
            return 'Я вышел в подъезд';
        end;
    end;

    way = {
        'main_enter',
        'upstairsSquare',
        'lobby_start'
    };

}:with {
    obj {
        nam = '#ступеньки';
        act = pfn(walk, 'upstairsSquare');
    };
};

room {
    nam = 'upstairsSquare';
    disp = 'Площадка второго этажа';
    dsc = 'Я попал на лестничную площадку 2-го этажа.';
    decor = [[Прямо передо мной {#дверь|дверь} ведущая в помещения втрого этажа.^
        Слева от меня находится {лестница|лестница} на крышу.^
        Позади меня {#ступеньки|ступеньки}, ведущие вниз.
    ]];

    way = {
        'porch',
        'secondFloor'
    };
}:with {
    obj {
        nam = '#дверь';
        act = pfn(walk, 'secondFloor');
    };

    obj {
        nam = 'лестница';
        act = 'Выход на крышу закрыт, просто так туда не попасть.';
    };

    obj {
        nam = '#ступеньки';
        act = pfn(walk, 'porch');
    };
};

room {
    nam = 'secondFloor';
    disp = 'Второй этаж';
    dsc = 'Я в коридоре на втором этаже. Передо мной множество дверей.';
    decor = [[Одна {#дверь|дверь}, я знаю точно, ведет в кабинет Жанны.]];

    way = {
        'upstairsSquare',
        'jannaRoom'
    };
}:with {
    obj {
        nam = '#дверь';
        act = pfn(walk, 'jannaRoom');
    };
};

room {
    nam = 'jannaRoom';
    disp = 'Кабинет Жанны';
    dsc = 'Это кабинет Жанны, она наш партнер по бизнесу или что-то вроде того.';
    decor = [[За столом у компьютера сидит {Жанна|Жанна}, и чем-то активно занимается.]];

    way = {'secondFloor'};
}:with {
    obj {
        nam = 'Жанна';
        act = pfn(walkin, 'jannaDlg');
    }
};

room {
    nam = 'main_enter';
    disp = 'Крыльцо';
    dsc = [[Я стою прямо перед главным входом в нашу фирму. Передо мной бывшее здание завода,
            теперь здесь сдаются в аренду помещения для разных частных контор.]];
    decor  = [[Справа здание огибает {#дорога|дорога} на склад, который находится с противоположной стороны здания.^
        Позади меня расположен {въезд|въезд} на территорию бывшего завода. Через него сотрудники фирмы попадают на работу.
    ]];

    way = {'porch', 'way_to_stock'};
}:with {
    obj {
        nam = '#дорога';
        act = pfn(walk, 'way_to_stock')
    };

    obj {
        nam = 'въезд';
        act = function()
            if achievs.main then
                if triggers.romantic then
                    achievs.romantic = true;
                    updateStat(achievs);
                    walk('romantic_end');
                else
                    walk('casual_end');
                end;
            else
                p 'Рабочий день еще не закончился, домой уходить рано!';
            end;
        end;
    };
};

room {
    nam = 'romantic_end';
    disp = 'Вечерняя прогулка с девушкой';
    dsc = [[Ну вот и закончен долгий рабочий день!^
        Мы стоим с Катей на берегу и смотрим на закат.^^
        
        Надеюсь Вам было интересно!^
        Спасибо Петру Косых за идею и реализацию движка.^^
        И спасибо Вам, за прохождение!
    ]];
};

room {
    nam = 'casual_end';
    disp = 'Конец рабочего дня';
    dsc = [[Ну вот и закончен очередной рабочий день! 
        Не каждый день приходилось лазать по крышам и чердакам, на самом деле, 
        это вообще был единственный раз, но квест был еще тот! ^
        Примерно в то же время я узнал о существовании INSTEAD и решил попробовать запилить на нем свою игру.
        Чтобы не заморачиваться с сюжетом, я считерил - просто взял свой, не самый обычный, рабочий день, и ничего придумывать уже не надо было! ).^
        Но процесс написания затянулся у меня на много лет... 
        Надеюсь Вам было интересно!^
        Спасибо Петру Косых за идею и реализацию движка.^^
        И спасибо Вам, за прохождение!
    ]];
};

room {
    nam = 'way_to_stock';
    disp = 'Дорога на склад';
    dsc = 'Я иду по длинной дороге которая огибает здание.';
    decor = [[Среди кустов виднеется старая, ржавая {#лестница|лестница} на крышу.]];

    way = {'main_enter', 'stock_enter'};
}:with {
    obj {
        nam = '#лестница';
        act = 'Лестница довольно старая, того и глядишь - отвалится, по ней я точно не буду лазать.';
    };
};

room {
    nam = 'stock_enter';
    disp = 'У входа на склад';
    enter = function(this, from)
        if from^'ladder' then
            p 'Я успешно спустился с лестницы, надеюсь, больше на нее лезть не придется.';
        end;
    end;
    dsc = [[Я стою перед входом в складские помещения. Здесь шныряют туда-сюда грузчики,
            экспедиторы с грузовиками забирают свой груз.]];
    decor = [[Внутрь склада можно попасть через здоровенный {вход|вход}, в который мог бы пролезть грузовик.^
        Справа от входа, не подалеку виднеется пожарная {#лестница|лестница} на крышу.^
        Сверху над входом, среди всего прочего, виден черный {провод|провод}, который тянется по стене откуда-то с крыши
        и заходит внутрь склада через щель между косяком и стеной.
    ]];

    way = {
        'way_to_stock',
        'stock'
    };
}:with {
    obj {
        nam = 'вход';
        act = pfn(walk, 'stock');
    };

    obj {
        nam = '#лестница';
        act = function()
            if triggers.mainTask then
                p [[ Лестница выглядит жутко, но делать нечего, надо лезть, я придерживая рукой весь свой инвентарь,
                    хватаюсь за грязные прутья.
                ]];
                walk('ladder');
            else
                p 'Ни к чему мне сейчас лезть на крышу, да и высоты я боюсь.';
            end;
        end;
    };

    obj {
        nam = 'провод';
        act = 'Интересно, что это за провод, отсюда и не поймешь...';
    };
};

room {
    nam = 'ladder';
    disp = 'На лестнице';
    dsc = 'Вниз лучше не смотреть, я жутко боюсь высоты, а тут еще никакой страховки, ноги начинают предательски трястись...';
    
    way = {
        'roof_0',
        'stock_enter'
    };
};

room {
    nam = 'roof_0';
    disp = 'На крыше у лестницы';
    enter = function(this, from)
        if from^'ladder' then
            p 'Уф... страшное позади, теперь можно спокойно осмотреться.';
        else
            p 'Страшно поворачиваться лицом к краю, на эту лестницу лучше вставать задом.';
        end;
    end;
    dsc = 'Я стою у края крыши.';
    decor = [[Позади меня {#лестница|лестница}, передо мной просторная и широкая крыша бывшего завода. 
        Сбоку тянется плотный черный {#line|провод} из двух жил, конец которого уходит за край крыши.
    ]];
    
    way = {
        'roof_1'
    };
}:with {
    obj {
        nam = '#лестница';
        act = function()
            p 'Я аккуратненько задом встаю на лестницу, держась руками за ржавые перила.';
            walk('ladder');
        end;
    };
    
    obj {
        nam = '#line';
        act = 'Очевидно, это телефонный кабель, это его я видел на складе.';
    };
};

room {
    nam = 'roof_1';
    disp = 'Посреди крыши';
    dsc = 'Я стою посреди крыши, выстланной рубероидом, ветер приятно обдувает лицо.';
    decor = 'Сбоку от меня пролегает толстый черный {#line|кабель}.';
    
    way = {
        'roof_0',
        'roof_2'
    }
}:with {
    obj{
        nam = '#line';
        act = 'Черный кабель пролегает через всю крышу.';
    };
};

room {
    nam = 'roof_2';
    disp = 'Крыша у входа';
    dsc = 'Я нахожусь на крыше прямо над главным входом в офис.';
    decor = [[Прямо передо мной находится закрытая {#door|дверь}. Сбоку пролегает {#line|провод}.]];
    
    way = {
        'roof_1'
    };
}:with {
    obj {
        nam = '#line';
        act = 'Провод выходит из щели, рядом с дверью.';
    };
    
    obj {
        nam = '#door';
        act = 'Дверь закрыта изнутри, войти в нее не получится.';
    };
};

room {
    nam = 'stock';
    disp = 'Склад';
    dsc = [[Просторное складское помещение, с кучей коробок, шныряющих грузчиков и специфичным запахом.
        Чувствуется, что продуктами торгуем )
    ]];

    decor = [[Вдоль стены наверху расположена {проводка|проводка}. На складе есть много всего, требующего проводов:^
        {#cam|камеры слежения},^ компьютер,^ телефон,^ электричество.^
        Пучок проводов идет вдоль стены в сторону какого-то контейнера c {контейнер|дверью}. Внутри горит свет.
    ]];

    way = {'stock_enter', 'stock_point'};
}:with {
    obj {
        nam = 'проводка';
        act = 'Рассмотрев связку различных проводов, я нашел один черный провод, выходящий из щели между стеной и входным косяком.';
    };

    obj {
        nam = 'контейнер';
        act = pfn(walk, 'stock_point');
    };
    
    obj {
        nam = '#cam';
        act = 'Осмотрев помещение я обнаружил несколько камер под {#ceiling|потолком}.';
    };
    
    obj {
        nam = '#ceiling';
        act = 'На потолке недалеко от входа я обнаружил отверстие, достаточное, чтобы пролез человек. И даже {#ladder|лестница}, ведущая к нему, имеется.';
    };
    
    obj {
        nam = '#ladder';
        act = function()
            if triggers.openTechFloor then
                p 'Я забрался по лестнице и пролез через отверстие.';
                walk('tech_floor');
            else
                p(rndItem({
                    'Интересно что там.',
                    'Меня туда, наверное, не пустят.',
                    'Сейчас есть дела поважнее, чем лазать по всяким непонятным лестницам.',
                    'Можно, конечно, залезть в эту дыру... не знаю зачем, правда.'
                }));
            end;
        end;
    };
};

room {
    nam = 'tech_floor';
    disp = 'Технический этаж';
    dsc = 'Я попал на технический этаж';
    decor = [[Я стою на надстиле из {#fiberglass|стекловаты}. В полный рост здесь не выпрямишься. 
        Вдоль стены расположен ряд {#windows|окон} с деревянными рамами. 
        Поверх стекол к рамам прибита полиэтиленовая пленка, такую я видел на огородах, ей грядки от холода укрывают.
    ]];
    
    way = {'stock'};
}:with {
    obj {
        nam = '#fiberglass';
        act = 'Лучше не трогать стекловату, иначе буду потом весь чесаться.';
    };
    
    obj {
        nam = '#windows';
        act = 'Деревянная рама окна прибита небольшими загнутыми {#pin|гвоздями}.';
    };
    
    obj {
        nam = '#pin';
        act = 'Видимо гвозди загнули, потому что шляпки маленькие.';
    }
};

room {
    nam = 'little_roof';
    disp = 'На козырьке';
    enter = 'Я вылез из окна на козырек.';
    dsc = 'Козырек приделан под углом, поэтому с него легко упасть. Я держусь рукой за раму окна.';
    decor = 'Черный {#line|провод} свисает с края крыши и уходит в щель между козырьком и стеной.';
    
    way = {
        'tech_floor'
    };
}:with {
    obj {
        nam = '#line';
        act = 'Подтянув к себе провод свободной рукой, я обнаружил горелое {#spot|черное пятно} на изоляции, там где провод проходил рядом с козырьком.';
    };
    
    obj {
        nam = '#spot';
        act = 'Эврика! Да это же пробой! Видимо молния угодила в металлический козырек и повредила провод.';
    };
};

room {
    nam = 'stock_point';
	disp = 'Кабинет кладовщика';
	dsc = 'Это что-то вроде кабинета управляющего складом. Тут стоит довольно пыльный стол со стулом.';
	decor = [[На столе стоит {#монитор|монитор}, на который транслируется видео с камер слежения со складского помещения.^
        Рядом с монитором на столе лежит простенький {#телефон|телефонный аппарат}, для связи с главным офисом.^
        От телефонного аппарата тянется крепкий черный {#line|провод}. 
    ]];

    enter = 'Я открыл дверь и зашел внутрь контейнера. Здесь довольно тесно.';
	exit = 'Я покинул тесное помещение.';

	way = {'stock'};
}:with {
    obj {
        nam = '#монитор';
        act = 'Я вижу шесть прямоугольных областей, в каждой из которых идет свое видео в реальном времени.';
    };

    obj {
        nam = '#телефон';
        act = 'Я поднял трубку и приложил к уху - гудков не слышно, тишина.';
    };
    
    obj {
        nam = '#line';
        act = 'Довольно толстый двужильный кабель, такой, наверное, и 220 бы спокойно выдержал.';
    };
};
