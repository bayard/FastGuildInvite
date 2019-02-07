local L = FGI.L
local Locale = {}

local function defaultFunc(L,key)
	return key
end


Locale.ruRU = {
	["nil"] = '',
	["Режим приглашения"] = nil,
	invType = {[1] = "Только пригласить", [2] = "Отправить сообщение и пригласить", [3] = "Только сообщение"},
	["Обычный поиск"] = nil,
	["Расширенное сканирование"] = nil,
	["Умный поиск"] = nil,
	["Автоматическое увеличение детализации поиска"] = nil,
	["Дополнительные настройки сканирования"] = nil,
	["Запускать в фоновом режиме"] = nil,
	["Запускать поиск в фоновом режиме"] = nil,
	["Включить фильтры"] = nil,
	["Начать сканирование"] = nil,
	["Выбрать приглашения"] = nil,
	["Настройки"] = nil,
	["Диапазон уровней"] = nil,
	["Интервал"] = nil,
	["Количество уровней сканируемых за один раз"] = nil,
	["Фильтр рас начало:"] = nil,
	["Уровень, с которого начинается фильтр по расам"] = nil,
	["Откл."] = nil,
	["Фильтр классов начало:"] = nil,
	["Уровень, с которого начинается фильтр по классам"] = nil,
	["Выключить сообщения аддона"] = nil,
	["Не отображать в чате сообщения аддона"] = nil,
	["Выключить системные сообщения"] = nil,
	["Не отображать в чате системные сообщения"] = nil,
	["Выключить отправляемые сообщения"] = nil,
	["Не отображать в чате отправляемые сообщения"] = nil,
	["Не отображать значок у миникарты"] = nil,
	["Фильтры"] = nil,
	["Назначить кнопку (%s)"] = nil,
	["Настроить сообщения"] = nil,
	["Назначить клавишу для приглашения"] = nil,
	["Нажмите на фильтр для изменения состояния"] = nil,
	["Добавить фильтр"] = nil,
	["Обязательное поле \"Имя фильтра\", пустые текстовые поля не используются при фильтрации."] = "Обязательное поле \"Имя фильтра\",\nпустые текстовые поля не используются при фильтрации.",
	["Классы:"] = nil,
	["Игнорировать"] = nil,
	class = {
		DeathKnight = "Рыцарь смерти",
		DemonHunter = "Охотник на демонов",
		Druid = "Друид",
		Hunter = "Охотник",
		Mage = "Маг",
		Monk = "Монах",
		Paladin = "Паладин",
		Priest = "Жрец",
		Rogue = "Разбойник",
		Shaman = "Шаман",
		Warlock = "Чернокнижник",
		Warrior = "Воин",
	},
	["Расы:"] = nil,
	hordeRace = {
		Orc = "Орк",
		Undead = "Нежить",
		Tauren = "Таурен",
		Troll = "Тролль",
		BloodElf = "Эльф крови",
		Goblin = "Гоблин",
		Nightborne = "Ночнорожденный",
		HightmountainTauren = "Таурен Крутогорья",
		MagharOrc = "Маг'хар",
		Pandaren = "Пандарен",
	},
	allianceRace = {
		Human = "Человек",
		Dwarf = "Дворф",
		NightElf = "Ночной эльф",
		Gnome = "Гном",
		Draenei = "Дреней",
		Worgen = "Ворген",
		VoidElf = "Эльф Бездны",
		LightforgedDraenei = "Озаренный дреней",
		DarkIronDwarf = "Дворф из клана Черного Железа",
		Pandaren = "Пандарен",
	},
	["Имя фильтра"] = nil,
	["Сбросить"] = nil,
	["Фильтр по имени"] = nil,
	["Если имя игрока содержит введенную\nфразу, он не будет добавлен в очередь"] = nil,
	["Диапазон уровней (Мин:Макс)"] = nil,
	["Введите диапазон уровней для фильтра.\nНапример: %s55%s:%s58%s\nбудут подходить только те игроки, уровень\nкоторых варьируется от %s55%s до %s58%s (включительно)"] = nil,
	["Фильтр повторений в имени"] = nil,
	["Введите максимальное количество последовательных\nгласных и согласных, которое может содержать имя игрока.\nНапример: %s3%s:%s5%s\nБудет означать, что игроки с более чем %s3%s гласными подряд\nили более %s5%s согласными подряд не будут добавлены в очередь."] = nil,
	["Чтобы быть отфильтрованным, игрок должен соответствовать критериям ВСЕХ фильтров"] = nil,
	["Сохранить"] = nil,
	[" r-"] = " р-",
	[" c-"] = " к-",
	["Имя фильтра не может быть пустым"] = nil,
	["Имя фильтра занято"] = nil,
	["Поле может содержать только буквы"] = nil,
	["Числа не могут быть меньше или равны 0. Минимальный уровень не может быть больше максимального"] = nil,
	["Неправильный шаблон"] = nil,
	["Числа должны быть больше 0"] = nil,
	["Количество ошибок: %u"] = nil,
	help = {
		show = "/fgi show - Открыть главное окно аддона",
		resetDB = "/fgi resetDB - Очистить список отправленных приглашений.",
		resetWindowsPos = "/fgi resetWindowsPos - Сбросить позиции окон."
	},
	minimapHelp = "ЛКМ - приграсить\nПКМ - открыть главное окно\nShift+ЛКМ - пауза/продолжить\n\nОчередь: %u\nПрогресс: %s",
	AddonSettings = {
		size = {
			mainFrameW = 600,
			mainFrameH = 320,
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
			filtersFrameW = 600,
			filtersFrameH = 300,
			addFilter = 150,
			addfilterFrameW = 600,
			addfilterFrameH = 600,
			
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
			NightElf = 100,
			Gnome = 100,
			Draenei = 100,
			Worgen = 100,
			VoidElf = 100,
			LightforgedDraenei = 100,
			DarkIronDwarf = 100,
			
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
		values = {
			
		},
		Font = 'Interface\\AddOns\\FastGuildInvite\\fonts\\PT_Sans_Narrow.ttf',
		FontSize = 16,
	},
}
Locale.ruRU = setmetatable(Locale.ruRU, {__index=defaultFunc})


	
Locale.enUS = {}
Locale.enUS = setmetatable(Locale.enUS, {__index=defaultFunc})
	
	
local l = GetLocale()
FGI.settings = Locale.ruRU.AddonSettings
if Locale[l] then
	FGI.L = Locale[l]
	if FGI.L.AddonSettings and l ~= "ruRU" then
		for k,v in pairs(FGI.L.AddonSettings) do
			FGI.settings[k] = v
		end
	end
else
	FGI.L = Locale.ruRU
end
local faction = UnitFactionGroup("player")
if faction == "Horde" then
	FGI.L.factions = FGI.L.hordeRace
elseif faction == "Alliance" then
	FGI.L.factions = FGI.L.allianceRace
end


local size = FGI.settings.size
size.mainButtonsGRP = size.startScan + size.chooseInvites + size.settingsBtn
size.mainCheckBoxGRP = math.max(size.deepSearch, size.normalSearch, size.smartSearch, size.backgroundRun, size.enableFilters)
size.searchRangeGRP = math.max(size.lvlRange + size.raceFilterStart, size.searchInterval + size.classFilterStart)+30
size.settingsCheckBoxGRP = math.max(size.addonMSG, size.systemMSG, size.sendMSG, size.minimapButton)
size.settingsButtonsGRP = size.filters + size.keyBind + size.setMSG
size.raceShift = math.max(size.Ignore, size.DeathKnight, size.DemonHunter, size.Druid, size.Hunter, size.Mage, size.Monk, size.Paladin, size.Priest, size.Rogue, size.Shaman, size.Warlock, size.Warrior)
size.raceShift = size.raceShift - size.classLabel + 20
size.filterNameShift = {};local faction,factionList = UnitFactionGroup("player");if faction == "Horde" then factionList = FGI.L.hordeRace elseif faction == "Alliance" then factionList = FGI.L.allianceRace end for k,v in pairs(factionList) do table.insert(size.filterNameShift, size[k]) end size.filterNameShift = math.max(unpack(size.filterNameShift)) - size.raceLabel + 20;
size.filtersEdit = math.max(size.filterNameLabel, size.excludeNameLabel, size.lvlRangeLabel, size.excludeRepeatLabel)
 

FGI.settings.values.maxlvl = 120
FGI.settings.values.minlvl = 1
FGI.settings.values.searchInterval = 5
FGI.settings.values.raceFilterStart = FGI.settings.values.maxlvl+1
FGI.settings.values.classFilterStart = FGI.settings.values.maxlvl+1