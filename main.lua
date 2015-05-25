-- $Name: Приключения сисадмина в ООО "Алтай-продукт"$
game.forcedsc=true;
game.codepage="UTF-8";
game.act = 'Ничего не происходит';
game._brokenpc = 0; --номер сломаного компа
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
game.use = function(s,w)
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

NUM_QUESTS = 4; --число мини-квестов
game._quests=0; --число выполненных квестов
-- триггеры квестов, включаются по ходу игры, динамически
game._weatherquest = false; -- мини-квест с погодой
game._eatingquest = false; -- мини квест "похавать"
game._mainquest = false; -- главный мега-квест
game._makecopyquest = false; -- мини-квест "ксерокопирование"
game._pcfixing = false; -- мини-квест "починка компа"

main = room {
	enter = function(s,f)
		if f~='screen' then return 'Я сел на свое рабочее место'; end;
	end;
	exit = function(s,f)
			if f=='kab6' then return 'Я встал из-за компа'; end;
	end,
	nam = 'Рабочее место',
	dsc = 'Я нахожусь в кабинете №6 за компом',
	obj={'monitor','yashik'},
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
	dsc = [[То ли серверная, то ли кладовка, 
			здесь полно всякого хлама]],
	act = function(s,w)
		if w==6 then return 'Лучше не трогать этот страшный девайс.';end;
		if w==5 then return 'Можно конечно поотрубать свет в каких-то отделах, но боюсь меня за это не похвалят.' end;
		if w==4 then return 'Свитчи тоже лучше не трогать, пока все работает.';end;
		if w==3 then 
			return 'Мини-АТС, сюда подходят провода от всех аппаратов фирмы, а также 3 городские линии.';
		end;
		if w==2 then return 'Старенький системник с Linux-ом, обеспечивает безопасный доступ в инет и больше ничего.'; end;
		if w==1 then return 'Сервер без монитора, так что ничего интересного я тут не увижу.';end;
	end,
	obj = {
		vobj(1,'Сервер','На подставке стоит {сервер}.^'),
		vobj(2,'Шлюз','На сервере сверху стоит еще один {системник} - это наш шлюз в интернет.^'),
		vobj(3,'МиниАТС','На стене висит {мини АТС} фирмы Panasonic, к ней подходит куча проводов.^'),
		vobj(4,'Свитчи','Еще на стене висят {два свитча} D-Link, тоже с кучей проводов.^'),
		vobj(5,'Автомат','Неподалеку от свитчей, тоже на стене прикреплены {автоматы} электропитания.^'),
		vobj(6,'Отопление','На другой стене висит большой и страшный {агрегат} - это система автономного отоплления.^'),
	},
	way={'kab8'},
};

kab8 = room {
	enter = 'Я вошел в кабинет № 8',
	nam='Кабинет №8',
	act = function(s,w)
		if w==1 then
			return 'И о чем поговорить с бухами, о дебетах и кредитах? Не вдохновляет.';
		end;
		if w==2 then
			return goto('serv');
		end;
	end,
	way={'koridor1','serv'},
	obj = {
		vobj(1,'бухи','Тут сидят обычные рядовые {бухи},'),
		vobj(2,'дверь','и находится {дверь} в серверную'),
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
		lifeon('cophumlife');
		return 'Я в кабинете № 6';
	end,
	exit = function()
		lifeoff('cophumlife');
		return;
	end,
	nam='Кабинет №6',
	dsc = 'Это мой кабинет, но кроме меня тут еще сидят бухи и главбух',
	obj = {'tabl','mfu1','hp1300','kor1door','copyhuman','cophumlife'},
	way = {'koridor1','main'},
};

kor1door = obj {
	nam = 'Дверь в коридор',
	dsc = 'Позади меня {дверь}, ведущая в коридор.',
	act = function()
		return goto('koridor1');
	end;
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
		if w==1 then return 'Диспетчера "вежливо" попросили не мешать работать, лучше их не злить.';end;
		if w==2 then
			if game._MFUvoid then return 'Закончился тонер. Теперь на нем копию не снимешь, пока не привезут новый тонер.';
			else return 'МФУ Kyocera TaskAlfa 180 формата А3, японская как видно из названия )';
			end;
		end;
	end,
	used = function(s,w1,w2)
		if w1==2 and w2=='sheetpaper' then
			if game._MFUvoid then return 'Копию снять нельзя, т.к. закончился тонер.';
			else return 'Диспетчера что-то копируют на ксероксе, думаю я не скоро дождусь, пока он освободится.';
			end;
		end;
		return w;
	end,
	way = {'koridor2'},
	obj = {
		vobj(1,'диспетчера','Тут трудятся {диспетчера}!!'),
		vobj(2,'МФУ','Посреди кабинета у стены стоит здоровое {МФУ}.'),
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
		if not wckey._opened then return 'Я не могу выйти, ведь дверь закрыта', false;
		end;
	end;
	obj={'unitaz','wckey','rakovina'},
	way = {'koridor3'},
};

wc2 = room {
	enter = 'Я пришел в туалет',
	nam = 'Туалет второй',
	dsc = 'Это обычный туалет',
	exit = function()
		if not wckey._opened then return 'Я не могу выйти, ведь дверь закрыта', false;
		end;
	end;
	obj={'unitaz','wckey','rakovina'},
	way = {'koridor3'},
};

rakovina = obj{
	nam = 'раковина',
	dsc = 'Сбоку на стене приделана {раковина} с кранами.',
	act = function()
		if game._dirtyhands then
			game._dirtyhands=false;
			return 'Я вымыл руки.';
		else return 'Руки еще не замарались, зачем их так часто мыть?';
		end;
		
	end,
};

wckey = obj{
	_opened = true;
	nam = 'ключ',
	dsc = function(o)
		local s='Дверь закрыта.';
		if o._opened then s='Дверь открыта.';
		end;
		return 'В двери вставлен {ключ}. '..s;
	end,
	act = function(s)
		s._opened=not s._opened;
		return 'Я поворачиваю ключ.';
	end,
};

unitaz = obj{
	nam = 'унитаз',
	dsc = 'В конце туалета как и положено расположен {унитаз}.',
	act = function()
		if wckey._opened then return 'А вдруг кто-нибудь зайдет и увидит?';
		else return 'Вообще-то, я пока не хочу в туалет';
		end;
	end;
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
			if game._eatingquest then food:enable();
			else food:disable();
			end;
			return	'Это кухня, тут мы едим';
	end,
	obj = {'food','vegafood','cooker'},
	way = {'archiveroom'},
};

cooker = obj{
	nam = 'Повар',
	dsc = 'На кухне хозяйничает наш повар {Елена Ивановна}.',
	act = function()
		 return goto('cookerdlg');
	end,
};

cookerdlg = dlg{
	nam = 'разговор с поваром',
	dsc = 'Я подошел к нашему повару. Не молодая женщина в переднике и косынке',
	obj = {
	[1] = phr('Здравствуйте!','Здравствуй!'),
	[2] = _phr('А можно что-нибудь съесть?','Да, конечно, приятного аппетита',[[pon(3)]]),
	[3] = _phr('Но я не могу это есть, я вегетарианец!','Ой, прости, сейчас чтонибудь придумаем...',[[vegafood:enable();pon(5);back()]]),
	[4] = _phr('Спасибо!','На доброе здоровье!',[[pon(4);back()]]),
	[5] = _phr('Хорошо'),
	},
	exit = function()
		pon(1);
		return 'Повар продолжила заниматься своими делами';
	end;
};

vegafood = obj{
	nam = 'вега-еда',
	dsc = 'Повар поставила на стол {вегетарианскую еду}, кажется это я могу есть.',
	act = function(s)
		if not game._dirtyhands then
			s:disable();
			cookerdlg:pon(4);
			game._quests=game._quests+1;
			game._eatingquest = false;
			return 'Я поел, теперь можно спокойно работать дальше';
		else return 'Я же не буду есть с грязными руками!';
		end;
	end,
}:disable();

food = obj {
	nam = 'еда',
	dsc = 'На столе стоит {еда}, кажется это макароны с гарниром и котлетой.',
	act = function()
		cookerdlg:pon(2);
		return 'Но я вегетарианец и такое не ем, что же делать, не помирать же с голоду?';
	end;
}:disable();

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

yashik = obj {
	nam = 'Ящик стола',
	_items = 3;
	_isopened = false;
	dsc = function (s)
			local mess=", выдвижной {ящик} в столе";
			if s._isopened then 
				mess=mess.." открыт.";
				if s._items ~= 0 then mess=mess.." В ящике лежит"; end;
			else mess=mess.." закрыт.";
			end;
			return mess;
	end,
	act = function (s) 
			s._isopened=not s._isopened;
			if s._isopened then 
				s:enable_all();
				return 'я открыл ящик';
			else 
				s:disable_all();
				return 'я закрыл ящик';
			end;
	end,
	obj =  {'otvertka','termopasta','smazka'}; 
	
};

smazka = obj {
	nam = 'смазка',
	dsc = function()
			local b = "";
			if not have('termopasta') then b = ", "; end;
			return b.."{смазка}.";
	end,
	tak = function()
		yashik._items = yashik._items-1;
		return 'я взял смазку';
	end,
	inv = 'это смазка, чтобы кулеры не гудели :)',
} :disable();

termopasta = obj{
	nam = 'термопаста',
	dsc = function()
		local b='';
		if have('smazka') then b='.'; end;
		return '{термопаста}'..b;
	end,
	tak = function()
		yashik._items = yashik._items-1;
		return 'я взял термопасту';
	end,
	inv = 'термопаста обеспечивает хорошую теплопроводность между процессором и радиатором',
} :disable();

otvertka = obj {
	nam = 'отвертка',
	dsc = function()
			local b=",";
			if have('termopasta') and have('smazka') then b="."; end;
			return "{отвертка}"..b;
	end,
	tak = function()
		yashik._items = yashik._items-1;
		return 'я взял отвертку';
	end,
	inv = 'обычная крестовая отвертка, универсальная :)',
} :disable();

vkontakte= function()
	local r=rnd(6);
	local mess={
	[1]='Я проверил сообщения в контакте',
	[2]='Я добавил новых друзей',
	[3]='Я написал письмо подружке',
	[4]='Меня отметили на новых фотографиях',
	[5]='Прочитал новое сообщение на стене',
	[6]='Мою фотографию прокоментировали',
	};
	return mess[r];
end;

weatherpaper=obj{
	nam = 'Распечатка погоды',
	_fromgoogle=false;
	_correct=false;
	dsc = function()
		return 'В принтере лежит {распечатка погоды}';
	end,
	act = 'Это распечатка погоды, директор попросил',
	tak = 'Я взял распечатку погоды.',
	inv = 'Прогноз погоды на ближайшие дни.',
}:disable();

weather = dlg{
	enter = 'Я ввожу в строке поиска ПОГОДА...',
	nam = 'Список ссылок',
	dsc = 'На экране несколько ссылок с погодой',
	obj = {
	[1]=phr('Погода в России. Распечатать','Я пускаю погоду на печать',[[pon(1);weatherpaper:enable();goto('kab6');]]),
	[2]=phr('Погода в Москве. Распечатать','Я пускаю погоду на печать',[[pon(2);weatherpaper:enable();goto('kab6');]]),
	[3]=phr('Погода в Барнауле. Распечатать','Я пускаю погоду на печать',[[pon(3);weatherpaper._correct=true;weatherpaper:enable();goto('kab6');]]),
	[4]=phr('Назад','Я закрываю поисковик',[[return back()]]),
	},
};

seeweather = function()
	if game._weatherquest then
		return goto('weather');
	else
		weatherpaper._fromgoogle=false;
		return 'Мне нечего искать в поисковике';
	end;
end;

screen = dlg{
	enter = 'На экране запущен браузер. Я вижу перед собой несколько быстрых ссылок',
	nam = 'Экран',
	obj = {
	[1]=phr('www.vkontakte.ru','',[[pon(1);return vkontakte();]]),
	[2]=phr('livejournal.com','',[[pon(2);return 'В ЖЖ ничего нового']]),
	[3]=phr('google.com','',[[pon(3);weatherpaper._fromgoogle=true;return seeweather()]]),
	[4]=phr('yandex.ru','',[[pon(4);return seeweather()]]),
	},
	way = {'main'},
};

monitor = obj {
	nam = 'монитор',
	dsc = 'На столе стоит {монитор}',
	act = function()
		return goto('screen')
	end,
};

hp1300 = obj {
	nam = 'Принтер',
	dsc = '^^Около главбуха стоит {принтер}.',
	act = 'Принтер HP LJ 1300, старенький но работает',
	obj = {'weatherpaper'},
};

tabl = obj{
	nam = 'Стол',
	dsc = 'В кабинете стоит мой {стол} с компьютером',
	act = function()
		return goto('main');
	end,
	obj = {'yashik'},
};

mfu1 = obj{
	_fixed = false;
	_paperinside = false;
	nam = 'Sharp AL-1217',
	dsc = 'Рядом со столом стоит старое {МФУ} Sharp.',
	used = function(s,w)
		if w=='sheetpaper' then
			return goto('mfuscene');
		else return 'Ну и зачем?';
		end;
	end;
	act = function(s)
			local l='';
			if s._paperinside then	
				mfucover:enable();
				l='Осмотрев МФУ, сбоку я обнаружил крышку.';
			end;
			return 'Старая МФУ-шка, уже снятая с производства, модель Sharp AL-1217. '..l;
	end,
	obj = {'mfucover'},
};

mfuscene = room {
	_copymode= false;
	enter = 'На лицевой панели МФУ располагаются органы управления',
	nam = 'ксерокопирование',
	act = function(s,w)
		if w==1 then
			s._copymode = not s._copymode;
			if s._copymode then return 'Режим работы - копирование';
			else return 'Режим работы - сканирование';
			end;
		end;
		if w==2 then
			if mfucover._opened then
				return 'Крышка МФУ открыта, в этом состоянии он не будет работать';
			else
				if mfu1._paperinside then
					return 'Кажется внутри зажевана бумага, сначала надо ее вытащить.';
				else
					if s._copymode then
						if mfu1._fixed then
							if game._makecopyquest then
								game._quests=game._quests+1;
								game._makecopyquest = false;
								mfu1.fixed = false;
								back();
								inv():del('sheetpaper');
								copyhuman:disable();
								game._MFUvoid = false;
								return 'Ну все, кажется копия успешно снялась, УРА!';
							else 
								back();
								inv():del('sheetpaper');
								return 'Копия успешно снялась!';
							end;
						else 
							mfu1._paperinside = true;
							return 'Ну вот, МФУ зажевал бумагу. Он очень старый я ведь предупреждал.';
						end;
					else
						return 'МФУ стоит в режиме сканирования. В этом режиме копии не снимаются.';
					end;
				end;
			end;
		end;
		if w==3 then
			return 'Я настроил изображение получше. Но кажется и так было неплохо. '
		end;
	end,
	obj = {
		vobj(1,'кнопка 1','{Кнопка} переключения режима.^'),
		vobj(2,'кнопка 2','{Кнопка} копирования.^'),
		vobj(3,'кнопки ','{Кнопки} настройки изображения.^'),
	},
	way = {'kab6'},
};

mfucover = obj{
	_opened = false;
	nam = 'крышка от мфу',
	dsc = function(s)
		if s._opened then
			return '{Крышка} МФУ открыта.';
		else return 'Сбоку у МФУ есть {крышка}.';
		end;
	end,
	act = function(s,w)
		if w==1 then
			if not s._opened then
				s._opened = true;
				bolt:enable();
				if mfu1._paperinside then badpaper:enable(); end;
				return 'Я нажал на защелку, крышка открылась.';
			else return 'Крышка уже открыта, ни к чему нажимать на защелку.';
			end;
		else 
			if s._opened then
				s._opened=false;
				if mfu1._paperinside then badpaper:disable(); end;
				bolt:disable();
				return 'Я захлопнул крышку';
			else return 'Крышка закрыта.';
			end;
		end;
	end,
	obj = {
		vobj(1,'защелка','Крышка закрывается посредством {защелки}.'),
		'bolt',
		'badpaper'
	},
}:disable();

badpaper = obj {
	nam = 'смятый лист',
	dsc = 'В механизме виден смятый {лист бумаги}.',
	act = function(s)
		s:disable();
		mfu1._paperinside = false;
		return 'Я вытащил помятый лист из механизма';
	end,
	
}:disable();

sheetpaper = obj{
	nam = 'какой-то документ',
	inv = 'Этот документ мне дали чтобы снять с него копию.',
};

bolt = obj{
	nam = 'болт',
	dsc = 'Рассмотрев внутренности МФУ я заметил один выделяющийся {болт}, который держит механизм.',
	act = function()
		if mfu1._fixed then
			return 'Отрегулированный болт, может быть теперь бумага не будет зажевываться.';
		else return 'Болт, держит механизм прохода бумаги. Его бы подрегулировать.';
		end;
	end,
	used = function(s,w)
		if mfu1._fixed then
			return 'Я уже отрегулировал болт, лучше к нему теперь не лезть.';
		else
			if w=='otvertka' then
				mfu1._fixed=true;
				return 'Я подрегулировал болт, кажется теперь не должно зажевывать.';
			else return 'Боюсь этим тут не поможешь.';
			end;
		end;
	end,
}:disable();

badpcdlg = dlg{
	nam = 'сломался комп',
	dsc = function()
		--mobile._calling=false;
		return 'Я снял трубку. Это звонят из кабинета '..game._brokenpc..'.';
	end,
	obj={
		[1] = phr('Алло!','Алло! Это системный администратор?',[[pon(2,3)]]),
		[2] = _phr('Да, что-то случилось?','У нас сломался компьютер.',[[pon(4);poff(3)]]),
		[3] = _phr('Нет, вы позвонили в администрацию президента.','Передайте президенту, что у нас сломался компьютер.',[[pon(4);poff(2)]]),
		[4] = _phr('Замечательно, а что с ним?','Что-то не работет - придите сами посмотрите.','pon(5)'),
		[5] = _phr('Хорошо, я подойду как освобожусь.'),
	},
	exit = function()
		lifeon('mobile');
		return 'Отлично, теперь еще и комп чинить :(';
	end,
};

mainquestdlg = dlg{
	nam = 'главный квест',
	dsc = 'Это звонит директор!',
	obj = {
		[1] = phr('Алло! Я слушаю.','Алексей! Зайди ко мне!','pon(2)'),
		[2] = _phr('Хорошо, сейчас приду.'),
	},
	exit = function()
		lifeon('mobile');
		return 'Интересно что же такого случилось...';
	end,
};

weatherquestdlg = dlg{
	nam = 'главный квест',
	dsc = 'Это снова звонит директор!',
	obj = {
		[1] = phr('Алло! Я слушаю.','Посмотри погоду в интернете, распечатай и принеси мне.','pon(2)'),
		[2] = _phr('Хорошо, я понял.'),
	},
	exit = function()
		lifeon('mobile');
		return 'Хм... нужно найти прогноз погоды в интернете..';
	end,
};

mobile = obj{
	r=1;
	--game._brokenpc=0;
	_calling=false;
	_state=0; --состояние 
	nam = 'мобильник',
	inv = function(s)
		if s._calling then
			lifeoff('mobile');
			s._calling=false;
			if s._state==1 then
				local num=rnd(8);
				if num==1 then kab1.obj:add('badpc') end;
				if num==2 then kab2.obj:add('badpc') end;
				if num==3 then kab3.obj:add('badpc') end;
				if num==4 then kab4.obj:add('badpc') end;
				if num==5 then kab5.obj:add('badpc') end;
				if num==6 then kab6.obj:add('badpc') end;
				if num==7 then kab7.obj:add('badpc') end;
				if num==8 then kab8.obj:add('badpc') end;
				game._brokenpc = num;
				game._pcfixing = true; -- включаем квест поломки компа
				return goto('badpcdlg');
			end;
			
			if s._state==2 then
				game._mainquest=true; -- включим главный мега-квест 
				return goto('mainquestdlg');
			end;
			
			if s._state==3 then
				game._weatherquest=true; -- включаем мини-квест с погодой через 50 ходов
				return goto('weatherquestdlg');
			end;
			
			
			return 'Состояние: '..s._state;
		else
			return 'Это мой мобильник Motorolla C650, старенький, такие сейчас не в моде.';		
		end;
	end,
	life = function(s)
		r=r+1;
		if r==3 then --должно быть 3, 0 для отладки
			s._calling=true;
			s._state=2;
		end;
		if r==50 then 
			s._calling=true;
			s._state=3;
		end;
		if r==10 then 
			game._eatingquest = true;
		end;
		
		local rn=rnd(30); --потом проверить возможность одновременного срабатывания рэндома и счетчика
		if rn==15 and not game._pcfixing and not s._calling then
			s._calling=true;
			s._state=1;		
		end;
		
		if s._calling then
			return 'У меня звонит мобильник!';
		else 
			if game._eatingquest and r%2==0 then return 'Что-то я проголодался, надо бы поесть...';
			else return;
			end;
		end;
	end,
};

badpc = obj{
	nam = 'сломаный комп',
	dsc = 'Вам показали на сломаный {комп} в кабинете.',
	
};

cophumlife=obj{
	nam = 'фиктивная сотрудница',
	life= function(s)
		local r = rnd(10);
		if r >8 then
			copyhuman:enable();
			lifeoff(s);
		end;
		--return string.rep('1',r);
	end,
};

copyhuman = obj{
	nam = 'сотрудница',
	dsc = 'В кабинет пришла {сотрудница} кажется ей что-то от меня нужно.',
	act = function()
		return goto('copydlg');
	end,
	
}:disable();

copydlg = dlg{
-- здесь поставить на выбор случайную фотку из 5
	nam = 'разговор с сотрудницей',
	enter = function(s)
		if game._makecopyquest then
			s:pon(6);
		else
			s:pon(1);
		end;
		return;
	end,
	dsc = 'Одна из наших сотрудниц.',
	obj = {
	[1]=_phr('Чем-то помочь?','Да, мне нужно отксерокопировать документ.',[[r=rnd(2)+1;pon(r);]]),
	[2]=_phr('А при чем тут я - ксерокс находится в 4м кабинете.','Да, но в нём закончился тонер',[[pon(4);game._MFUvoid = true;]]),
	[3]=_phr('Ксерокс у нас находится в 4м кабинете.','Тот ксерокс занят и надолго.',[[pon(4);game._MFUvoid = false;]]),
	[4]=_phr('Хм.. странно, только что вроде все было нормально...','Можно использовать этот ксерокс? (показывает на МФУ возле моего стола)',[[pon(5);]]),
	[5]=_phr('Это плохой ксерокс, он жует бумагу, но можно попробовать.','Копи нужна очень срочно! Вот этот документ.',[[inv():add('sheetpaper');pon(6);game._makecopyquest = true;return back()]]),
	[6]=_phr('Вы все еще тут?','Да, нельзя ли побыстрее, копия нужна срочно!'),
	},
},

inv():add('mobile');
lifeon('mobile');
r=0;
game._dirtyhands = true;
game._MFUvoid = false;