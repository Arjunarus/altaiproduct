include "scenes/main_enter"
include "scenes/endGame"

include "scenes/way_to_stock"
include "scenes/stock_enter"
include "scenes/ladder"
include "scenes/roof"
include "scenes/stock"
include "scenes/stock_point"
include "scenes/tech_floor"
include "scenes/little_roof"

include "scenes/porch"
include "scenes/upstairsSquare"
include "scenes/secondFloor"
include "scenes/jannaRoom"
include "scenes/archiveroom"
include "scenes/kitchen"
include "scenes/wc"
include "scenes/lobby"
include "scenes/cab1"
include "scenes/cab2"
include "scenes/cab3"
include "scenes/cab4"
include "scenes/cab5"
include "scenes/cab6"
include "scenes/wplace"
include "scenes/cab7"
include "scenes/cab8"
include "scenes/serv"

room {
    nam = 'main';
    disp = 'Приключения эникейщика в ООО "Молоко"';
    dsc = [[
        Эта история приключилась со мной, когда я работал на должности 'эникейщика'
        в одной Барнаульской фирме в период 2009 -- 2010 гг. Сейчас этой фирмы уже нет.
        Занималась она дистрибуцией продуктов питания, преимущественно молочной продукцией ВБД (Вимм Билль Данн).
        Периодически на фирме происходили факапы разной степени тяжести: то отопление прорвет,
        то электрики в проводке напутают ну и все в таком роде :)^
        Один рабочий день мне особо запомнился, он и послужил сюжетом для данной
        игры. Основано на реальных событиях! ^^
    ]];

}:with {
    obj {
        dsc = '{Желаю приятного квеста!}';
        act = function()
            take('status')
            take('mobile')
            walk('wplace')
            lifeon()
            lifeon('mobile', 1)
        end;
    };
};
