dlg {
    nam = 'principalDlg_1';
	disp = 'Разговор с директором';
	dsc = 'Это звонит директор!';
    exit = 'Так-с, директору как обычно нужно распечатать погоду.';
    
    phr = {
        {'Алло! Я слушаю.', 'Посмотри погоду в интернете, распечатай и принеси мне.',
            {'Хорошо, я понял.'}
        }
    };
}

dlg {
    nam = 'weatherDlg';
    disp = 'Разговор с директором';
    dsc = 'Ну что принес погоду?';

    noinv = true;

    phr = {
        only = true,

        {
            cond = function() return have('weatherPaper') end,

            'Да принес вот держите.',
            function()
                p 'Хмм.. посмотрим.'

                if _'weatherPaper'.place == 'Барнаул' and _'weatherPaper'.src == 'Yandex' then
                    p 'Хорошо, то что надо, спасибо!'
                    triggers.weather = false
                    achievs.weather = true
                    updateStat(achievs)
                elseif _'weatherPaper'.place == 'Новосибирск' then
                    p 'Предлагаешь поехать в Новосибирск на выходные?'
                elseif _'weatherPaper'.src ~= 'Yandex' then
                    p 'Что-то я тут нифига не понимаю, распечатай нашу погоду из Яндекса и принеси мне!'
                end

                if _'weatherPaper'.place ~= 'Барнаул' then
                    p 'Ты что, забыл в каком городе мы живем??'
                end

                disable('weatherPaper')
                place('weatherPaper', 'hp_lj_1300')
                walkout()
            end
        },

        {'Нет пока, еще не успел распечатать...','Ну давай быстрее!'}
    };
}