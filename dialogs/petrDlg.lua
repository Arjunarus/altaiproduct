dlg {
    nam = 'petrDlg';
    disp = 'Разговор с Петровичем';
    noinv = true;
    
    phr = {
        {
            'Здравствуйте!',
            'Привет!'
        },
        
        {
            'Не знаете, случайно, что там за проблема со складом?',
            'Не знаю, сегодня с утра связь не работает. Возможно где-то обрыв, а ночью еще и гроза была.',
            
            {
                'А провод по крыше пролегает, или где-то по стенам?',
                'Да, по крыше, но я там обрыва не нашел, я уже там все посмотрел - все нормально, провод целый.',
                
                {
                    'Вы лазали на крышу?',
                    'Да, но больше я туда не полезу, по этой лестнице ржавой, ну ее нахер!'
                }
            },
            
            {
                'А у вас есть ключ от крыши?',
                'Не, у меня нету.',
                
                {
                    'Как же туда попасть?',
                    'Я по пожарной лестнице лазал, но больше не полезу, нахер такое счастье.'
                }
            }
        }
    };
}