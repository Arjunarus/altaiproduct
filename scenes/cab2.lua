room {
    nam = 'cab2';
    disp = 'Кабинет №2';
    dsc = 'Кабинет директора, тоже очень главный!! отсюда часто доносятся громкие крики...';
    decor = [[За крутым директорским столом, на крутом кожаном кресле сидит наш директор -- {principal|Михалыч}]];
    onexit = function()
        if achievs.weather and not triggers.mainTask then
            p 'Подожди не уходи! Есть еще кое что!'
            return false
        end;
    end;
    
    onenter = function(this, w)
        if have('weatherPaper') == nil then
            p 'Это кабинет директора, лучше туда не заходить просто так.'
            return false
        else
            return 'Я вошел в кабинет № 2.'
        end
    end;

    way = {'lobby_middle'};

}:with {
    obj {
        nam = 'principal';
        disp = 'Директор';
        act = function()
            if achievs.weather and not triggers.mainTask then
                walkin('mainTaskDlg')
                triggers.mainTask = true
            else
                p 'Нужна веская причина чтобы отвлекать директора.'
            end
        end;
        
        used = function(this, what)
            if what.nam == 'weatherPaper' then
                walkin('weatherDlg')
            else
                return false
            end
        end;
    };
};