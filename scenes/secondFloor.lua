room {
    nam = 'secondFloor';
    disp = 'Второй этаж';
    dsc = 'Я в коридоре на втором этаже. Передо мной множество дверей.';
    decor = [[Одна {#дверь|дверь}, я знаю точно, ведет в кабинет Жанны.]];

    way = {
        'upstairsSquare',
        'jannaRoom'
    };
}:with {
    obj {
        nam = '#дверь';
        act = pfn(walk, 'jannaRoom');
    };
};