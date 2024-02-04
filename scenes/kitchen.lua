room {
    nam = 'kitchen';
    disp = 'Кухня';
    decor = function()
        p [[На кухне хозяйничает наш повар {повар|Елена Ивановна}.^]]

        if disabled('vegaFood') then
            p 'На столе стоит вкусный {еда|борщ} с капусткой, но не красный, {еда|сосисочки}.'
        else
            p 'Она поставила на стол {vegaFood|борщ} с капусткой но без мяса, какой-то {vegaFood|салат} '
            p(fmt.st('(куда крошат морковку, капусту и яблоки с ананасами)'))
            p 'вкусный {vegaFood|чай}. Я чувствую себя человеком!'
        end
    end;

    enter = 'Я пришел на кухню, тут мы едим';

    way = {'archiveroom'};
}:with {
    obj {
        nam = 'повар';
        act = pfn(walkin, 'cookerDlg');
    };

    obj {
        nam = 'vegaFood';

        act = function(this)
            if not triggers.dirtyHands then
                achievs.eat = true
                triggers.wantToEat = false
                updateStat(achievs)
                p 'Я поел, теперь можно спокойно работать дальше'
                disable('vegaFood')
            else
                p 'Я же не буду есть с грязными руками, так и заболеть можно!'
            end
        end,
    }:disable();

    obj {
        nam = 'еда';
        act = function()
            if achievs.eat then
                p 'Я уже поел.'
            else
                return rndItem({
                    'Я уже 5 лет как вегетарианец злой, с каждой ЗП я покупаю курицу и отпускаю ее на волю!',
                    'Не ем я такое, нельзя мне.',
                    "I just don't eat meat",
                    'Я, просто, не ем мясо - это нормально..',
                    'Я вегетарианец, кстати, прекрасно себя чувствую! А вы нет? Это все из-за мяса! :)',
                    'Некоторые люди почему-то не едят мясо, так вот, я как раз один из них )'
                })
            end
        end;
    };
};