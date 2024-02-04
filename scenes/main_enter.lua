room {
    nam = 'main_enter';
    disp = 'Крыльцо';
    dsc = [[Я стою прямо перед главным входом в нашу фирму. Передо мной бывшее здание завода,
            теперь здесь сдаются в аренду помещения для разных частных контор.]];
    decor  = [[Справа здание огибает {#дорога|дорога} на склад, который находится с противоположной стороны здания.^
        Позади меня расположен {въезд|въезд} на территорию бывшего завода. Через него сотрудники фирмы попадают на работу.
    ]];

    way = {'porch', 'way_to_stock'};
}:with {
    obj {
        nam = '#дорога';
        act = pfn(walk, 'way_to_stock')
    };

    obj {
        nam = 'въезд';
        act = function()
            if achievs.main then
                if triggers.romantic then
                    achievs.romantic = true
                    updateStat(achievs)
                    walk('romantic_end')
                else
                    walk('casual_end')
                end
            else
                p 'Рабочий день еще не закончился, домой уходить рано!'
            end
        end;
    };
};