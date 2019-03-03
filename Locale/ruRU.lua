local L = {
	["FAQ"] = {
		["help"] = {
			["factorySettings"] = "/fgi factorySettings - Полный сброс базы данных аддона",
			["filter"] = "ЛКМ - Включить/Выключить\nПКМ - Изменить\nShift+ЛКМ - Удалить\n\n",
			["filterTooltip"] = "Имя фильтра: %s\nСостояние:%s\nФильтр имени: %s\nДиапазон уровней: %s\nФильтр повторений в имени:%d:%d\nКлассы: %s\nРасы: %s\nКоличество срабатываний фильтра:%d",
			["minimap"] = "ЛКМ - пригласить\nПКМ - открыть главное окно\nShift+ЛКМ - пауза/продолжить\n\nОчередь: %d\nПрогресс: %s",
			["resetDB"] = "/fgi resetDB - Очистить список отправленных приглашений.",
			["resetWindowsPos"] = "/fgi resetWindowsPos - Сбросить позиции окон.",
			["show"] = "/fgi show - Открыть главное окно аддона",
		},
		["error"] = {
			["Вы не состоите в гильдии или у вас нет прав для приглашения."] = "Вы не состоите в гильдии или у вас нет прав для приглашения.",
			["Выберите сообщение"] = "Выберите сообщение",
			["Максимальное количество фильтров %s. Пожалуйста измените или удалите имеющийся фильтр."] = "Максимальное количество фильтров %s. Пожалуйста измените или удалите имеющийся фильтр.",
			["Нельзя добавить пустое сообщение"] = "Нельзя добавить пустое сообщение",
			["Нельзя сохранить пустое сообщение"] = "Нельзя сохранить пустое сообщение",
			["Поиск вернул 50 или более результатов, рекомендуется изменить настройки поиска. Запрос: %s"] = "Поиск вернул 50 или более результатов, рекомендуется изменить настройки поиска. Запрос: %s",
			["Сочетание клавиш уже занято"] = "Сочетание клавиш уже занято",
			["Превышен лимит символов. Максимальная длина сообщения 255 символов. Длина сообщения превышена на %d"] = "Превышен лимит символов. Максимальная длина сообщения 255 символов. Длина сообщения превышена на %d",
		}
	},
	["interface"] = {
		["Игрок не добавлен в список исключений."] = "Игрок не добавлен в список исключений.",
		["Для изменения значений используйте колесо мыши"] = "Для изменения значений используйте колесо мыши",
		["Включен"] = "Включен",
		["Включить фильтры"] = "Включить фильтры",
		["Выбрать приглашения"] = "Выбрать приглашения",
		["Выключен"] = "Выключен",
		["Выключить отправляемые сообщения"] = "Выключить отправляемые сообщения",
		["Выключить системные сообщения"] = "Выключить системные сообщения",
		["Выключить сообщения аддона"] = "Выключить сообщения аддона",
		["Да"] = "Да",
		["Диапазон уровней"] = "Диапазон уровней",
		["Диапазон уровней (Мин:Макс)"] = "Диапазон уровней (Мин:Макс)",
		["Добавить"] = "Добавить",
		["Добавить фильтр"] = "Добавить фильтр",
		["Запускать в фоновом режиме"] = "Запускать в фоновом режиме",
		["Игнорировать"] = "Игнорировать",
		["Имя фильтра"] = "Имя фильтра",
		["Имя фильтра занято"] = "Имя фильтра занято",
		["Имя фильтра не может быть пустым"] = "Имя фильтра не может быть пустым",
		["Интервал"] = "Интервал",
		["Классы:"] = "Классы:",
		["Количество ошибок: %d"] = "Количество ошибок: %d",
		["Нажмите на фильтр для изменения состояния"] = "Нажмите на фильтр для изменения состояния",
		["Назначить кнопку (%s)"] = "Назначить кнопку (%s)",
		["Настроить сообщения"] = "Настроить сообщения",
		["Настройки"] = "Настройки",
		["Начать сканирование"] = "Начать сканирование",
		["Не отображать значок у миникарты"] = "Не отображать значок у миникарты",
		["Неправильный шаблон"] = "Неправильный шаблон",
		["Нет"] = "Нет",
		["Обычный поиск"] = "Обычный поиск",
		["Обязательное поле \"Имя фильтра\", пустые текстовые поля не используются при фильтрации."] = "Обязательное поле \"Имя фильтра\",\nпустые текстовые поля не используются при фильтрации.",
		["Откл."] = "Откл.",
		["Отклонить"] = "Отклонить",
		["Поле может содержать только буквы"] = "Поле может содержать только буквы",
		["Пригласить"] = "Пригласить",
		["Пригласить: %d"] = "Пригласить: %d",
		["Расширенное сканирование"] = "Расширенное сканирование",
		["Расы:"] = "Расы:",
		["Режим приглашения"] = "Режим приглашения",
		["Сбросить"] = "Сбросить",
		["Слово NAME заглавными буквами будет заменено на название вашей гильдии."] = "Слово NAME заглавными буквами будет заменено на название вашей гильдии.",
		["Сохранить"] = "Сохранить",
		["Текущее сообщение: %s"] = "Текущее сообщение: %s",
		["Удалить"] = "Удалить",
		["Умный поиск"] = "Умный поиск",
		["Фильтр классов начало:"] = "Фильтр классов начало:",
		["Фильтр по имени"] = "Фильтр по имени",
		["Фильтр повторений в имени"] = "Фильтр повторений в имени",
		["Фильтр рас начало:"] = "Фильтр рас начало:",
		["Фильтры"] = "Фильтры",
		["Числа должны быть больше 0"] = "Числа должны быть больше 0",
		["Числа не могут быть меньше или равны 0. Минимальный уровень не может быть больше максимального"] = "Числа не могут быть меньше или равны 0. Минимальный уровень не может быть больше максимального",
		["Чтобы быть отфильтрованным, игрок должен соответствовать критериям ВСЕХ фильтров"] = "Чтобы быть отфильтрованным, игрок должен соответствовать критериям ВСЕХ фильтров",
		["tooltip"] = {
			["Автоматическое увеличение детализации поиска"] = "Автоматическое увеличение детализации поиска",
			["Введите диапазон уровней для фильтра.\nНапример: %s55%s:%s58%s\nбудут подходить только те игроки, уровень\nкоторых варьируется от %s55%s до %s58%s (включительно)"] = "Введите диапазон уровней для фильтра.\nНапример: %s55%s:%s58%s\nбудут подходить только те игроки, уровень\nкоторых варьируется от %s55%s до %s58%s (включительно)",
			["Введите максимальное количество последовательных\nгласных и согласных, которое может содержать имя игрока.\nНапример: %s3%s:%s5%s\nБудет означать, что игроки с более чем %s3%s гласными подряд\nили более %s5%s согласными подряд не будут добавлены в очередь."] = "Введите максимальное количество последовательных\nгласных и согласных, которое может содержать имя игрока.\nНапример: %s3%s:%s5%s\nБудет означать, что игроки с более чем %s3%s гласными подряд\nили более %s5%s согласными подряд не будут добавлены в очередь.",
			["Дополнительные настройки сканирования"] = "Дополнительные настройки сканирования",
			["Если имя игрока содержит введенную\nфразу, он не будет добавлен в очередь"] = "Если имя игрока содержит введенную\nфразу, он не будет добавлен в очередь",
			["Запускать поиск в фоновом режиме"] = "Запускать поиск в фоновом режиме",
			["Количество уровней сканируемых за один раз"] = "Количество уровней сканируемых за один раз",
			["Назначить клавишу для приглашения"] = "Назначить клавишу для приглашения",
			["Не отображать в чате отправляемые сообщения"] = "Не отображать в чате отправляемые сообщения",
			["Не отображать в чате системные сообщения"] = "Не отображать в чате системные сообщения",
			["Не отображать в чате сообщения аддона"] = "Не отображать в чате сообщения аддона",
			["Уровень, с которого начинается фильтр по классам"] = "Уровень, с которого начинается фильтр по классам",
			["Уровень, с которого начинается фильтр по расам"] = "Уровень, с которого начинается фильтр по расам",
		},
		["invType"] = {
			["Отправить сообщение и пригласить"] = "Отправить сообщение и пригласить",
			["Только пригласить"] = "Только пригласить",
			["Только сообщение"] = "Только сообщение",
		}
	},
	["SYSTEM"] = {
		["c-"] = "к-",
		["r-"] = "р-",
		["class"] = {
			["DeathKnight"] = "Рыцарь смерти",
			["DemonHunter"] = "Охотник на демонов",
			["Druid"] = "Друид",
			["Hunter"] = "Охотник",
			["Mage"] = "Маг",
			["Monk"] = "Монах",
			["Paladin"] = "Паладин",
			["Priest"] = "Жрец",
			["Rogue"] = "Разбойник",
			["Shaman"] = "Шаман",
			["Warlock"] = "Чернокнижник",
			["Warrior"] = "Воин",
		},
		["race"] = {
			["Horde"] = {
				["BloodElf"] = "Эльф крови",
				["Goblin"] = "Гоблин",
				["HightmountainTauren"] = "Таурен Крутогорья",
				["MagharOrc"] = "Маг'хар",
				["Nightborne"] = "Ночнорожденный",
				["Orc"] = "Орк",
				["Pandaren"] = "Пандарен",
				["Tauren"] = "Таурен",
				["Troll"] = "Тролль",
				["Undead"] = "Нежить",
			},
			["Alliance"] = {
				["DarkIronDwarf"] = "Дворф из клана Черного Железа",
				["Draenei"] = "Дреней",
				["Dwarf"] = "Дворф",
				["Gnome"] = "Гном",
				["Human"] = "Человек",
				["LightforgedDraenei"] = "Озаренный дреней",
				["NightElf"] = "Ночной эльф",
				["Pandaren"] = "Пандарен",
				["VoidElf"] = "Эльф Бездны",
				["Worgen"] = "Ворген",
			}
		}
	}
}
L.settings = {
	size = {
		mainFrameW = 600,
		mainFrameH = 320,
		wheelHint = 350,
		inviteTypeGRP = 200,
		normalSearch = 120,
		deepSearch = 210,
		smartSearch = 110,
		backgroundRun = 220,
		enableFilters = 150,
		startScan = 160,
		chooseInvites = 180,
		settingsBtn = 120,
		lvlRange = 150,
		searchInterval = 120,
		raceFilterStart = 160,
		classFilterStart = 160,
		settingsFrameW = 550,
		settingsFrameH = 200,
		addonMSG = 230,
		systemMSG = 245,
		sendMSG = 270,
		minimapButton = 260,
		filters = 150,
		keyBind = 200,
		setMSG = 160,
		filtersFrameW = 620,
		filtersFrameH = 300,
		addFilter = 150,
		addfilterFrameW = 600,
		addfilterFrameH = 600,
		messageFrameW = 600,
		messageFrameH = 300,
		save = 100,
		delete = 100,
		add = 100,
		chooseInvitesW = 400,
		chooseInvitesH = 100,
		reject = 100,
		invite = 100,
		
		classLabel = 60,
		Ignore = 120,
		DeathKnight = 130,
		DemonHunter = 160,
		Druid = 70,
		Hunter = 80,
		Mage = 50,
		Monk = 70,
		Paladin = 80,
		Priest = 60,
		Rogue = 95,
		Shaman = 70,
		Warlock = 120,
		Warrior = 60,
		
		raceLabel = 60,
		Orc = 50,
		Undead = 80,
		Tauren = 75,
		Troll = 75,
		BloodElf = 100,
		Goblin = 75,
		Nightborne = 140,
		HightmountainTauren = 150,
		MagharOrc = 85,
		Pandaren = 95,
		Human = 100,
		Dwarf = 100,
		NightElf = 120,
		Gnome = 100,
		Draenei = 100,
		Worgen = 100,
		VoidElf = 130,
		LightforgedDraenei = 150,
		DarkIronDwarf = 160,
		
		filterNameLabel = 200,
		excludeNameLabel = 200,
		lvlRangeLabel = 200,
		excludeRepeatLabel = 200,
		saveButton = 100,
		
		scanFrameW = 260,
		scanFrameH = 105,
		inviteBTN = 120,
		clearBTN = 70,
	},
	Font = 'Interface\\AddOns\\FastGuildInvite\\fonts\\PT_Sans_Narrow.ttf',
	FontSize = 16,
}


FGI.L["ruRU"] = L