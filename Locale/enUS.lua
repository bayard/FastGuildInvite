-- if not(GetLocale() == "enUS") then
  -- return
-- end
local L = {
	["FAQ"] = {
		["help"] = {
			["factorySettings"] = "/fgi factorySettings - Full reset of the addon database",
			["filter"] = "LMB-enable/disable\nRMB-change\nShift+LMB-delete\n\n",
			["filterTooltip"] = "Filter Name:%s\nstatus:%s\nfilter by Name:%s\nlevel range:%s\nrepeat filter in name:%d:%d\nclasses:%s\nrace:%s\nnumber of filter triggers:%d",
			["minimap"] = "LMB-invite\nRMB-Open main window\nShift+:LMB-Pause/continue\n\nQueue:%d\nprogress:%s",
			["resetDB"] = "/fgi resetDB - Clear the list of sent invitations.",
			["resetWindowsPos"] = "/fgi resetWindowsPos - Reset the position of the window(s).",
			["show"] = "/fgi show - Open the main window of the addon",
		},
		["error"] = {
			["Вы не состоите в гильдии или у вас нет прав для приглашения."] = "You are not a member of the guild or you do not have permission to invite.",
			["Выберите сообщение"] = "Select message",
			["Максимальное количество фильтров %s. Пожалуйста измените или удалите имеющийся фильтр."] = "The maximum number of filters %s. Please change or remove existing filter.",
			["Нельзя добавить пустое сообщение"] = "Cannot add empty message",
			["Нельзя сохранить пустое сообщение"] = "Cannot save empty message",
			["Поиск вернул 50 или более результатов, рекомендуется изменить настройки поиска. Запрос: %s"] = "Search returned 50 or more results, it is recommended to change the search settings. Query: %s",
			["Сочетание клавиш уже занято"] = "Keyboard shortcut busy",
		}
	},
	["interface"] = {
		["Включен"] = "Included",
		["Включить фильтры"] = "Enable filters",
		["Выбрать приглашения"] = "Choose invitations",
		["Выключен"] = "Switched off",
		["Выключить отправляемые сообщения"] = "Disable sent messages",
		["Выключить системные сообщения"] = "Turn off system messages",
		["Выключить сообщения аддона"] = "Disable addon messages",
		["Да"] = "Yes",
		["Диапазон уровней"] = "Level range",
		["Диапазон уровней (Мин:Макс)"] = "Level Range (Min: Max)",
		["Добавить"] = "Add",
		["Добавить фильтр"] = "Add filter",
		["Запускать в фоновом режиме"] = "Run in the background",
		["Игнорировать"] = "Ignore",
		["Имя фильтра"] = "Filter name",
		["Имя фильтра занято"] = "Filter name is busy",
		["Имя фильтра не может быть пустым"] = "Filter name cannot be empty",
		["Интервал"] = "Interval",
		["Классы:"] = "Classes:",
		["Количество ошибок: %d"] = "Number of errors: %d",
		["Нажмите на фильтр для изменения состояния"] = "Click on the filter to change the state",
		["Назначить кнопку (%s)"] = "Assign button (%s)",
		["Настроить сообщения"] = "Customize posts",
		["Настройки"] = "Settings",
		["Начать сканирование"] = "Start Scan",
		["Не отображать значок у миникарты"] = "Do not display the minimap icon.",
		["Неправильный шаблон"] = "Wrong template",
		["Нет"] = "No",
		["Обычный поиск"] = "Normal Search",
		["Обязательное поле \\\"Имя фильтра\\\", пустые текстовые поля не используются при фильтрации."] = "Required field \\\"Filter name\\\",\\nempty text boxes are not used in filtering. ",
		["Откл."] = "Turn off",
		["Отклонить"] = "Reject",
		["Поле может содержать только буквы"] = "This field can only contain letters. ",
		["Пригласить"] = "Invite",
		["Пригласить: %d"] = "Invite: %d",
		["Расширенное сканирование"] = "Advanced Scan",
		["Расы:"] = "Race:",
		["Режим приглашения"] = "Invitation mode",
		["Сбросить"] = "Reset",
		["Слово NAME заглавными буквами будет заменено на название вашей гильдии."] = "The word NAME in capital letters will be replaced with the name of your guild.",
		["Сохранить"] = "Save",
		["Текущее сообщение: %s"] = "Current message: %s",
		["Удалить"] = "Delete",
		["Умный поиск"] = "Smart Search",
		["Фильтр классов начало:"] = "Class Filter Start:",
		["Фильтр по имени"] = "Filter by name",
		["Фильтр повторений в имени"] = "Repeat filter in Name",
		["Фильтр рас начало:"] = "Filter start races:",
		["Фильтры"] = "Filters",
		["Числа должны быть больше 0"] = "Numbers must be greater than 0",
		["Числа не могут быть меньше или равны 0. Минимальный уровень не может быть больше максимального"] = "Numbers cannot be less than or equal to 0. The minimum level cannot be greater than the maximum",
		["Чтобы быть отфильтрованным, игрок должен соответствовать критериям ВСЕХ фильтров"] = "To be filtered, the player must meet the criteria of all filters",
		["tooltip"] = {
			["Автоматическое увеличение детализации поиска"] = "Automatically increase search details.",
			["Введите диапазон уровней для фильтра.\\nНапример: %s55%s:%s58%s\nбудут подходить только те игроки, уровень\nкоторых варьируется от %s55%s до %s58%s (включительно)"] = "Enter a range of levels for the filter.\\nfor Example:%s55%s:%s58%s\nwill be approached only by those players, the level\nwhich varies from%s55%s to %s58%s (inclusive)",
			["Введите максимальное количество последовательных\nгласных и согласных, которое может содержать имя игрока.\\nНапример: %s3%s:%s5%s\nБудет означать, что игроки с более чем %s3%s гласными подряд\nили более %s5%s согласными подряд не будут добавлены в очередь."] = "Enter the maximum number of consecutive\nvowels and consonants that may contain the player's name.\\nfor Example:%s3%s:%s5%s\nwill mean that players with more than%s3%s vowels in a row\nor more%s5%s consonants will not be added to Queue.",
			["Дополнительные настройки сканирования"] = "Advanced Scan Settings",
			["Если имя игрока содержит введенную\nфразу, он не будет добавлен в очередь"] = "If the player name contains the entered\nphrase, it will not be added to the queue",
			["Запускать поиск в фоновом режиме"] = "Run a background search",
			["Количество уровней сканируемых за один раз"] = "Number of levels scanned at one time",
			["Назначить клавишу для приглашения"] = "Assign a key to the invitation",
			["Не отображать в чате отправляемые сообщения"] = "Do not show sent messages in chat",
			["Не отображать в чате системные сообщения"] = "Do not display system messages in Chat",
			["Не отображать в чате сообщения аддона"] = "Do not display addon messages in Chat",
			["Уровень, с которого начинается фильтр по классам"] = "The level at which the filter starts by class",
			["Уровень, с которого начинается фильтр по расам"] = "The level at which the race filter starts",
		},
		["invType"] = {
			["Отправить сообщение и пригласить"] = "Send a message and invite",
			["Только пригласить"] = "Only invite",
			["Только сообщение"] = "Message only",
		}
	},
	["SYSTEM"] = {
		["c-"] = "c-",
		["r-"] = "r-",
		["class"] = {
			["DeathKnight"] = "Death Knight",
			["DemonHunter"] = "Demon Hunter",
			["Druid"] = "Druid",
			["Hunter"] = "Hunter",
			["Mage"] = "Mage",
			["Monk"] = "Monk",
			["Paladin"] = "Paladin",
			["Priest"] = "Priest",
			["Rogue"] = "Rogue",
			["Shaman"] = "Shaman",
			["Warlock"] = "Warlock",
			["Warrior"] = "Warrior",
		},
		["race"] = {
			["Horde"] = {
				["BloodElf"] = "Blood Elf",
				["Goblin"] = "Goblin",
				["HightmountainTauren"] = "Highmountain Tauren",
				["MagharOrc"] = "Mag'har Orc",
				["Nightborne"] = "Nightborne",
				["Orc"] = "Orc",
				["Pandaren"] = "Pandaren",
				["Tauren"] = "Tauren",
				["Troll"] = "Troll",
				["Undead"] = "Undead",
			},
			["Alliance"] = {
				["DarkIronDwarf"] = "Dark Iron Dwarf",
				["Draenei"] = "Draenei",
				["Dwarf"] = "Dwarf",
				["Gnome"] = "Gnome",
				["Human"] = "Human",
				["LightforgedDraenei"] = "Lightforged Draenei",
				["NightElf"] = "Night Elf",
				["Pandaren"] = "Pandaren",
				["VoidElf"] = "Void Elf",
				["Worgen"] = "Worgen",
			}
		}
	}
}


L.settings = {
	size = {
		Mage = 60,
		Priest = 80,
		Shaman = 80,
		Warrior = 80,
	}
}


FGI.L["enUS"] = L