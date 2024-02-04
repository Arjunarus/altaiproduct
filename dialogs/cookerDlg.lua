dlg {
    nam = 'cookerDlg';
    disp = 'Разговор с поваром';
    enter = 'Я подошел к нашему повару - не молодая женщина в переднике и косынке.';

    noinv = true;

    phr = {
        only = true,

        {
            '#hello',
            'Здравствуйте!',
            'Здравствуй!'
        },
        {
            only = true,

            cond = function()
                return triggers.wantToEat
            end,

            'А нельзя ли что-нибудь съесть?',
            'Да, конечно, там на столе - это тебе. Приятного аппетита.',

            {
                'Но я же не ем мясное!',

                function()
                    p 'Ой, прости, сейчас что-нибудь придумаем...'
                    enable('vegaFood')
                    close('#hello')
                end
            },
            {
                'Спасибо!',
                'На доброе здоровье!'
            };
        },

        {
            cond = function()
                return achievs.eat
            end,

            'Спасибо, было вкусно!',
            'На доброе здоровье!'
        }
    };
}