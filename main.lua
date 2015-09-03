-- $Name: Приключения эникейщика в ООО "Рога и копыта"$
-- $Version: 0.2$
-- $Author: ArjunaRus - http://vk.com/arjunarus $

instead_version "1.9.1"
require "para"
require "dash"
require "quotes"
require "nouse"
require "hideinv"

require "dbg"

--game.forcedsc = true;
game.codepage = "UTF-8";

game.act = 'Ничего не происходит';
game.inv = function(s,w)
	local r = rnd(6);
	local mes={
	[1]='Интересная штуковина..',
	[2]='Хм..',
	[3]='Как вы думаете, что это?',
	[4]='Симпатичная вещица, не так ли?',
	[5]='Забавная штука.',
	[6]='Куда бы это применить?',
	};
	return mes[r];
end;
game.nouse = function(s,w)
	local r = rnd(6);
	local mes={
	[1]='Не применяется...',
	[2]='Не пойму как это тут применить..',
	[3]='Ну и причем тут '..ref(w).nam..'?',
	[4]='Не срабатывает.',
	[5]='Ну и что к чему?',
	[6]='Да вы что, это же '..ref(w).nam..'!',
	};
	return mes[r];
end;


function init()

end;

main = room {
	enter = function(s,f)
		if f~='screen' then return 'Я сел на свое рабочее место'; end;
	end;
	exit = function(s,f)
			if f=='kab6' then return 'Я встал из-за компа'; end;
	end,
	nam = 'Рабочее место',
	dsc = 'Я нахожусь в кабинете №6 за компом',
--	obj={'monitor','yashik'},
	way={'kab6'},
};


koridor1 = room {
	enter=function(s,f)
		if f=='koridor2' then return 'Я перешел в конец коридора';
		else return 'Я вышел в коридор';
		end;
	end,
	nam = 'Конец коридора',
	dsc = 'Это самый конец коридора',
	way={'kab8','kab7','kab6','koridor2'},
};

koridor2 = room {
	enter=function(s,f)
		if f=='koridor1' or f=='koridor3' then
			return 'Я прошел вдоль по коридору';
		else 
			return 'Я вышел в коридор';
		end;
	end,
	nam = 'Середина коридора',
	dsc = 'Я стою посреди коридора, передо мной множество дверей',
	way={'kab5','kab4','kab3','kab2','koridor1','koridor3'},
};

koridor3 = room {
	enter=function(s,f)
		if f=='koridor2' then return 'Я перешел в начало коридора';
		elseif f=='vihod' then return 'Я вошел в коридор нашей фирмы';
		else return 'Я вышел в коридор';
		end;
	end,
	nam = 'Начало коридора',
	dsc = 'Тут начинается коридор и видно несколько дверей',
	way={'kab1','vihod','koridor2','wc1','wc2','archiveroom'},
};

serv = room {
	enter = 'Я вошел в серверную, тут довольно тесно.',
	nam = 'Серверная',
	dsc = [[То ли серверная, то ли кладовка, здесь полно всякого хлама]],
	act = function(s,w)
		if w=='Отопление' then return 'Лучше не трогать этот страшный девайс.';end;
		if w=='Автомат' then return 'Можно конечно поотрубать свет в каких-то отделах, но боюсь меня за это не похвалят.' end;
		if w=='Свитчи' then return 'Свитчи тоже лучше не трогать, пока все работает.';end;
		if w=='МиниАТС' then 
			return 'Мини-АТС, сюда подходят провода от всех аппаратов фирмы, а также 3 городские линии.';
		end;
		if w=='Шлюз' then return 'Старенький системник с Linux-ом, обеспечивает безопасный доступ в инет и больше ничего.'; end;
		if w=='Сервер' then return 'Сервер без монитора, так что ничего интересного я тут не увижу.';end;
	end,
	obj = {
		vobj('Сервер','На подставке стоит {сервер}.^'),
		vobj('Шлюз','На сервере сверху стоит еще один {системник} - это наш шлюз в интернет.^'),
		vobj('МиниАТС','На стене висит {мини АТС} фирмы Panasonic, к ней подходит куча проводов.^'),
		vobj('Свитчи','Еще на стене висят {два свитча} D-Link, тоже с кучей проводов.^'),
		vobj('Автомат','Неподалеку от свитчей, тоже на стене прикреплены {автоматы} электропитания.^'),
		vobj('Отопление','На другой стене висит большой и страшный {агрегат} - это система автономного отоплления.^'),
	},
	way={'kab8'},
};

kab8 = room {
	enter = 'Я вошел в кабинет № 8',
	nam='Кабинет №8',
	act = function(s,w)
		if w=='бухи' then
			return 'И о чем поговорить с бухами, о дебетах и кредитах? Не вдохновляет.';
		end;
	end,
	way={'koridor1','serv'},
	obj = {
		vobj('бухи','Тут сидят обычные рядовые {бухи},'),
		vway('дверь','и находится {дверь} в серверную', 'serv'),
	},
};

kab7 = room {
	enter = 'Я вошел в кабинет № 7',
	nam='Кабинет №7',
	dsc = 'Тут заседают логисты, и еще тут часто рубятся в ирушки',
	way = {'koridor1'};
};

kab6 = room {
	enter = function()
--		lifeon('cophumlife');
		return 'Я в кабинете № 6';
	end,
	exit = function()
--		lifeoff('cophumlife');
		return;
	end,
	nam='Кабинет №6',
	dsc = 'Это мой кабинет, но кроме меня тут еще сидят бухи и главбух',
--	obj = {'tabl','mfu1','hp1300','kor1door','copyhuman','cophumlife'},
	way = {'koridor1','main'},
};


kab5 = room {
	enter = 'Я вошел в кабинет № 5',
	nam = 'Кабинет №5',
	dsc = 'Тут работает наш кассир, и еще иногда выдают зарплату',
	way = {'koridor2'};
};

kab4 = room {
	enter = 'Я вошел в кабинет № 4',
	nam='Кабинет №4',
	dsc = 'Это самый главный кабинет.',
	act = function(s,w)
		if w=='диспетчера' then return 'Диспетчера "вежливо" попросили не мешать работать, лучше их не злить.';end;
		if w=='МФУ' then
			if game._MFUvoid then return 'Закончился тонер. Теперь на нем копию не снимешь, пока не привезут новый тонер.';
			else return 'МФУ Kyocera TaskAlfa 180 формата А3, японская как видно из названия )';
			end;
		end;
	end,
	used = function(s,w1,w2)
		if w1=='МФУ' and w2=='sheetpaper' then
			if game._MFUvoid then return 'Копию снять нельзя, т.к. закончился тонер.';
			else return 'Диспетчера что-то копируют на ксероксе, думаю я не скоро дождусь, пока он освободится.';
			end;
		end;
		return w;
	end,
	way = {'koridor2'},
	obj = {
		vobj('диспетчера','Тут трудятся {диспетчера}!!'),
		vobj('МФУ','Посреди кабинета у стены стоит здоровое {МФУ}.'),
	},
};

kab3 = room {
	enter = 'Я вошел в кабинет № 3',
	nam='Кабинет №3',
	dsc = 'Кабинет колбасного отдела',
	way = {'koridor2'};
};

kab2 = room {
	enter = 'Я вошел в кабинет № 2',
	nam='Кабинет №2',
	dsc = 'Кабинет директора, тоже очень главный!! отсюда часто доносятся громкие крики...',
	way = {'koridor2'};
};

kab1 = room {
	enter = 'Я вошел в первый кабинет',
	nam='Кабинет №1',
	dsc = 'Это торговый отдел, тут сидят супервайзеры',
	way = {'koridor3'};
};

wc1 = room {
	enter = 'Я пришел в туалет',
	nam = 'Туалет первый',
	dsc = 'Это обычный туалет',
	exit = function()
--		if not wckey._opened then return 'Я не могу выйти, ведь дверь закрыта', false;
--		end;
	end;
--	obj={'unitaz','wckey','rakovina'},
	way = {'koridor3'},
};

wc2 = room {
	enter = 'Я пришел в туалет',
	nam = 'Туалет второй',
	dsc = 'Это обычный туалет',
	exit = function()
--		if not wckey._opened then return 'Я не могу выйти, ведь дверь закрыта', false;
--		end;
	end;
--	obj={'unitaz','wckey','rakovina'},
	way = {'koridor3'},
};


archiveroom = room {
	enter = 'Я зашел в архивную комнату',
	nam = 'Архивная',
	dsc = 'Эта комната что-то вроде большой кладовки. Здесь по ночам сидят сторожа.',
	act = function(s,w)
		if w==1 then
			return 'Лучше я не буду сейчас включать телевизор.';
		end;
		if w==2 then
			return 'Коробки с документами, а также пустые коробки от тубы для Kyocera TaskAlfa 180';
		end;
	end;
	obj={
		vobj(1,'телевизор','В углу стоит {телевизор}, чтобы сторожам не было скучно.'),
		vobj(2,'коробки','Вдоль стен навалена куча {коробок}.'),
	},
	way = {'koridor3','kitchen'},
};

kitchen = room {
	enter = function()
			return	'Я пришел на кухню';
	end,
	nam = 'Кухня',
	dsc = function()
--			if game._eatingquest then food:enable();
--			else food:disable();
--			end;
--			return	'Это кухня, тут мы едим';
	end,
--	obj = {'food','vegafood','cooker'},
	way = {'archiveroom'},
};

vihod = room{
	enter=function(s,f)
		if f=='street' then return 'Я вошел в здание';
		else return 'Я вышел в подъезд';
		end;
	end,
	nam = 'Подъезд',
	dsc = 'Это можно назвать подъездом, тут ничего интересного',
	way={'koridor3','street'},
};

street = room{
	nam = 'Улица',
	dsc = 'Я вышел на улицу',
	way = {'vihod'},
};
