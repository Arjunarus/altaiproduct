room {
    nam = 'wplace';
    disp = 'Рабочее место';
    dsc = [[Я нахожусь в кабинете №6 за своим рабочим местом.]];
    decor = function()
        p 'На столе стоит небольшой {монитор|монитор}.'
        if seen('landline_phone') then
            p 'Справа от меня стоит старый красный {landline_phone|телефон}.'
        end
    end;

    enter = function(this, f)
        if f.nam == 'cab6' then
            return 'Я сел на свое рабочее место.'
        end
    end;

    way = {
        path {'Встать из за стола', 'cab6'}
    };
    
    obj = {'landline_phone'};
    
}:with {
    obj {
        nam = 'монитор';
        disp = 'монитор';
        act = pfn(walkin, 'screen');
    };
};