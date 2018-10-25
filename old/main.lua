
instead_version "1.9.1"
require "para"
require "dash"
require "quotes"
require "nouse"
require "hideinv"

require "dbg"

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

