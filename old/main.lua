
instead_version "1.9.1"
require "para"
require "dash"
require "quotes"
require "nouse"
require "hideinv"

require "dbg"

--======================================================================

isMfp1Jammed = function()
    return (exist(jammedPaper, mfpInside) ~= nil);
end;

mfp1 = obj { 
    -- nam = 'Sharp AL-1217';
    -- dsc = 'Рядом со столом стоит старое {МФУ Sharp}.';
    -- used = function(s, w)
        -- if w == someDocument then
            -- p('Я поместил ' .. w.nam .. ' внутрь МФУ на стекло сканера.');
            -- placef(w, s);
            -- inv():del(w);
        -- else
            -- p(rndItem({w.verb .. 'МФУ? Хм... ну не знаю, не знаю...',
                        -- 'Можно конечно ' .. w.verb .. 'МФУ, но непонятно что делать потом..'}));
        -- end;
        -- return true;
    -- end;
    
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

--======================================================================

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

