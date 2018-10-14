
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

