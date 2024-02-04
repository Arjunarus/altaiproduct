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
                walkin('petrDlg')
            else
                p 'Это наш завхоз Петрович.'
                p 'Петрович у нас отвечает за электрику, отопление ну и всё в таком духе.'
            end
        end;
    };
};