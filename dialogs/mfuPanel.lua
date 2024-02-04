dlg {
    nam = 'mfuPanel';
    disp = 'Ксерокопирование';
    dsc = 'На лицевой панели МФУ располагаются органы управления';

    copyMode = false;
    noinv = true;

	phr = {
		{
            always = true,

            'Кнопка переключения режима.',
            function()
                _'mfuPanel'.copyMode = not _'mfuPanel'.copyMode
                if _'mfuPanel'.copyMode then
                    p 'Режим работы: копирование'
                else
                    p 'Режим работы: сканирование'
                end
            end,
        },

        {
            always = true,

            'Кнопка копирования.',
            function()
                p 'Я нажал кнопку копирования...^^'

                if not _'mfuPanel'.copyMode then
                    p 'МФУ стоит в режиме сканирования. В этом режиме копии не снимаются.'
                elseif _'mfpCover'.opened then
                    p 'Крышка МФУ открыта, в этом состоянии он не будет работать'
                elseif not disabled('jammedPaper') then
                    p 'Кажется внутри зажевана бумага, сначала надо ее вытащить.'
                elseif not _'mfpCover'.fixed then
                    enable('jammedPaper')
                    p 'Ну вот, МФУ зажевал бумагу. Он очень старый я ведь предупреждал!'
                else
                    remove('someDocument')
                    _'mfpCover'.fixed = false -- Only one copy is possible after fixing
                    achievs.copy = true
                    updateStat(achievs)
                    disable('copyWoman')
                    triggers.needCopy = false
                    p 'Ну все, кажется копия успешно снялась, УРА!'
                end

                walkout()
            end
        },

        {
            always = true,
            'Кнопки настройки изображения.',
            'Я настроил изображение получше. Хотя, вроде, и так было норм.'
        }
	};
}