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
            p 'Диспетчера "вежливо" попросили не мешать работать, лучше их не злить.'
            walk('lobby_middle')
        end;
    };
    obj {
        nam = 'МФУ';
        act = 'МФУ Kyocera TaskAlfa 180 формата А3, японская, как видно из названия :)';
        used = function(this, w)
            if w.nam == 'someDocument' then
                p 'Тонер закончился, так что снять копию не получится.'
            else
                p(rndItem({
                    'Предлагаете ' .. w.verb .. ' МФУ? Хм... ну не знаю, не знаю...',
                    'Можно конечно ' .. w.verb .. ' МФУ, можно еще и диспетчеров ' .. w.verb .. '.'
                }))
            end
        end;
    };
};