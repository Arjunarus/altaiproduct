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
        ]]
        if not _'#slot':disabled() then
            p 'Один свободный {#slot|слот} - в него был подключен кабель от склада.'
        end
    end;

    enter = 'Я вошел в серверную, тут довольно тесно.';
    
    obj = {'tape'};
    way = {'cab8'};
}:with {
    'stock_line';
    
    obj {
        nam = '#cords';
        act = function()
            if triggers.mainTask then
                if triggers.seenStockLine then
                    p 'Среди кучи одинаковых проводов я замечаю один {stock_line|черный}, точно такой же я видел на складе.'
                else
                    p 'Если бы я знал какой из них отвечает за склад...'
                end
            else
                p 'Сюда подключены телефонные линии со всех кабинетов.'
            end
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
        nam = 'сервер';
        act = 'Сервер без монитора, так что ничего интересного я тут не увижу.';
    };
    
    obj {
        nam = 'шлюз';
        act = function()
            p 'Старенький системник с Linux-ом, обеспечивает безопасный доступ в инет и больше ничего.'
            if seen('tape') then
                p 'Сверху на системнике я заметил {tape|изоленту}.'
            end
        end;
    };
    
    obj {
        nam = 'МиниАТС';
        act = function()
            p 'Мини-АТС, сюда подключены все телефонные аппараты фирмы, а также 3 городские линии.'
            if triggers.mainTask and where('cable') and where('cable').nam == 'МиниАТС' then
                p 'Я вижу свободный конец {cable|кабеля}, который ни к чему не подключен.'
            end
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
            })
        end;
    };
    
    obj {
        nam = 'Отопление';
        act = function(this)
            return rndItem({
                'Лучше не трогать этот страшный девайс.',
                'А что, может отопление отключим? Гыыы ))',
                'Все равно сейчас не отопительный сезон.'
            })
        end;
    };
};