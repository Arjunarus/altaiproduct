room {
    nam = 'cab6';
    disp = 'Кабинет №6';
    dsc = [[Это мой рабочий кабинет, но кроме меня тут еще сидят бухи и главбух.]];
    decor = [[В кабинете стоит мой {стол|стол} с компьютером. Около главбуха стоит {hp_lj_1300|принтер}.
        Рядом со столом стоит старое {mfp_1|МФУ Sharp}.
    ]];

    enter = function(this, f)
        if f.nam == 'wplace' then
            return 'Я встал из-за стола.'
        end
        
        -- Enable copy woman in 1 time from 5 entering
        if rnd(5) % 3 == 0 and not achievs.copy then
            enable('copyWoman')
        end
        
        return 'Я в кабинете № 6.'
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
                p('В сканере МФУ находится {someDocument|какой-то документ}.')
            end
        end;

        act = function(this)
            if not disabled('jammedPaper') and disabled('mfpCover') then
                enable('mfpCover')
                return 'Осмотрев МФУ, сбоку я обнаружил крышку.'
            elseif lookup('someDocument', this) ~= nil then
                walkin('mfuPanel')
                return
            else
                p [[Старая МФУ-шка, уже снятая с производства, модель Sharp AL-1217.]]
            end
        end;

        used = function(this, w)
            if w.nam == 'someDocument' then
                p('Я поместил ' .. w.disp .. ' внутрь МФУ на стекло сканера.')
                place(w, this)
            else
                p(rndItem({
                    'Хотите ' .. w.verb .. ' МФУ? Хм... ну не знаю, не знаю...',
                    'Можно конечно ' .. w.verb .. ' МФУ, но непонятно что делать потом..'
                }))
            end
        end;

    }:with {
        obj {
            nam = '#lock';
            disp = 'защелка';

            act = function(this)
                p 'Я нажал на защелку, крышка открылась.'
                _'mfpCover'.opened = true
            end;
        };

        obj {
            nam = 'mfpCover';
            fixed = false;
            opened = false;

            -- TODO
            dsc = function(this)
                if this.opened then
                    return '{Крышка} МФУ открыта. Внутри МФУ выделяется один {screw|болт}, который держит механизм.'
                else
                    return '{Крышка} МФУ закрыта. Она защелкивается на {#lock|защелку}.'
                end
            end;

            act = function(this)
                if this.opened then
                    this.opened = false
                    return 'Я захлопнул крышку'
                else
                    return 'Крышка закрыта.'
                end
            end;
        }:disable();

        obj {
            nam = 'screw';
            disp = 'болт';

            act = function(this)
                if _'mfpCover'.fixed then
                    return 'Отрегулированный болт, может быть теперь бумага не будет зажевываться.'
                else
                    return 'Болт держит механизм прохода бумаги. Его бы подрегулировать..'
                end
            end;

            used = function(this, w)
                if w.nam == 'turn_screw' then
                    if (_'mfpCover'.fixed) then
                        return 'Я уже отрегулировал болт, лучше к нему теперь не лезть.';
                    end

                    _'mfpCover'.fixed = true
                    return 'Я подрегулировал болт, кажется теперь не должно зажевывать.'
                else
                    p(rndItem({
                        'Предлагаете ' .. w.verb .. ' болт? Мдя... его надо подрегулировать, а не ' .. w.verb .. '!',
                        'Можно конечно ' .. w.verb .. ' болт, а что потом?'
                    }))
                end
            end;
        };

        obj {
            nam = 'jammedPaper';
            disp = 'смятый лист';
            dsc = function(this)
                if _'mfpCover'.opened and not disabled('mfpCover') then
                    return 'В механизме виден смятый {лист бумаги}.'
                end
            end;

            act = function(this)
                disable(this)
                return 'Я вытащил помятый лист из механизма'
            end;
        }:disable();
    };

    obj {
        nam = 'copyWoman',
        disp = 'сотрудница';
        dsc = function()
            if have('someDocument') or lookup('someDocument', 'mfp_1') ~= nil then
                p '^В кабинете находится {сотрудница}, которой нужна копия документа.'
            else
                p 'В кабинет пришла {сотрудница} кажется ей что-то от меня нужно.'
            end
        end;
        
        act = function()
            walkin('copyDlg')
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
            p 'Принтер HP LJ 1300, старенький, но работает.'
            if where('weatherPaper').nam == 'hp_lj_1300' then
                p 'В принтере лежит {weatherPaper|распечатка погоды}.'
            end
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