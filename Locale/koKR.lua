-- if not(GetLocale() == "koKR") then
  -- return
-- end
local L = {
	["FAQ"] = {
		["help"] = {
			["factorySettings"] = "/fgi factorySettings - 전체 애드온 데이터베이스 재설정",
			["filter"] = "LMB - 사용함/사용안함\n PMM - 수정\nShift+LMB - 이동\n\n",
			["filterTooltip"] = "필터 이름:%s\n상태:%s\n이름 필터:%s\n레벨 범위:%s\n 이름의 중복 필터:%u:%u\n 클래스:%s\n특징::%s\n 필터 응답 수:%u",
			["minimap"] = "LMB - 초대\n PM - 기본 창을 엽니다.\nShift+LMB-일시 중지/계속\n\n 변경:%u\n 진행:%s",
			["resetDB"] = "/fgi resetDB - 보낸 초대장 목록을 지웁니다.",
			["resetWindowsPos"] = "/fgi resetWindowsPos - 창 위치를 재설정합니다.",
			["show"] = "/fgi show - 추가 기능 기본 창 열기",
		},
		["error"] = {
			["Вы не состоите в гильдии или у вас нет прав для приглашения."] = "님은 길드원이 아니거나 초대 할 권한이 없습니다.",
			["Выберите сообщение"] = "메시지 선택",
			["Максимальное количество фильтров %s. Пожалуйста измените или удалите имеющийся фильтр."] = "최대 필터 수는 %s입니다. 기존 필터를 변경하거나 제거하십시오.",
			["Нельзя добавить пустое сообщение"] = "빈 메시지를 추가 할 수 없습니다.",
			["Нельзя сохранить пустое сообщение"] = "빈 메시지를 저장할 수 없습니다.",
			["Поиск вернул 50 или более результатов, рекомендуется изменить настройки поиска. Запрос: %s"] = "검색 결과가 50 개 이상 검색되었습니다. 검색 설정을 변경하는 것이 좋습니다. 요청: %s",
			["Превышен лимит символов. Максимальная длина сообщения 255 символов. Длина сообщения превышена на %d"] = "문자 제한을 초과했습니다. 최대 메시지 길이는 255 자입니다. 메시지 길이가 %d을(를) 초과했습니다.",
			["Сочетание клавиш уже занято"] = "단축키가 이미 사용 중입니다.",
		}
	},
	["interface"] = {
		["Включен"] = "켜기",
		["Включить фильтры"] = "필터 사용",
		["Выбрать приглашения"] = "초대장 선택",
		["Выключен"] = "끄기",
		["Выключить отправляемые сообщения"] = "보낸 메시지 사용 안 함",
		["Выключить системные сообщения"] = "시스템 메시지 끄기",
		["Выключить сообщения аддона"] = "애드온 메시지 사용 중지",
		["Да"] = "예",
		["Диапазон уровней"] = "레벨 범위",
		["Диапазон уровней (Мин:Макс)"] = "레벨 범위 (최소:최대)",
		["Для изменения значений используйте колесо мыши"] = "마우스 휠을 사용하여 값을 변경하십시오.",
		["Добавить"] = "추가",
		["Добавить фильтр"] = "필터 추가",
		["Запускать в фоновом режиме"] = "백그라운드에서 실행",
		["Игнорировать"] = "무시",
		["Игрок не добавлен в список исключений."] = "플레이어는 예외 목록에 추가되지 않습니다.",
		["Имя фильтра"] = "필터 이름",
		["Имя фильтра занято"] = "필터 이름이 사용 중입니다.",
		["Имя фильтра не может быть пустым"] = "필터 이름은 비워 둘 수 없습니다.",
		["Интервал"] = "간격",
		["Классы:"] = "클래스:",
		["Количество ошибок: %d"] = "오류 수: %d",
		["Нажмите на фильтр для изменения состояния"] = "필터를 클릭하여 상태를 변경하십시오.",
		["Назначить кнопку (%s)"] = "할당 버튼 (%s)",
		["Настроить сообщения"] = "소식 맞춤 설정",
		["Настройки"] = "설정",
		["Начать сканирование"] = "스캔 시작",
		["Не отображать значок у миникарты"] = "미니 맵에 아이콘을 표시하지 마십시오.",
		["Неправильный шаблон"] = "잘못된 템플릿",
		["Нет"] = "아니요",
		["Обычный поиск"] = "일반 검색",
		["Обязательное поле \"Имя фильтра\", пустые текстовые поля не используются при фильтрации."] = "필수 필드 \"필터 이름\",\n 전체 텍스트 필드는 필터링 중에 사용되지 않습니다.",
		["Откл."] = "끄기",
		["Отклонить"] = "거절",
		["Поле может содержать только буквы"] = "필드는 문자만 포함 할 수 있습니다.",
		["Пригласить"] = "초대",
		["Пригласить: %d"] = "초대: %d",
		["Расширенное сканирование"] = "확장 스캔",
		["Расы:"] = "종족:",
		["Режим приглашения"] = "초대 모드",
		["Сбросить"] = "재설정",
		["Слово NAME заглавными буквами будет заменено на название вашей гильдии."] = "대문자로 된 NAME 단어가 길드 이름으로 대체됩니다.",
		["Сохранить"] = "저장",
		["Текущее сообщение: %s"] = "현재 메시지: %s",
		["Удалить"] = "삭제",
		["Умный поиск"] = "스마트 검색",
		["Фильтр классов начало:"] = "클래스 필터 시작:",
		["Фильтр по имени"] = "이름으로 필터링",
		["Фильтр повторений в имени"] = "이름 반복 필터",
		["Фильтр рас начало:"] = "종족 필터 시작:",
		["Фильтры"] = "필터",
		["Числа должны быть больше 0"] = "숫자는 0보다 커야합니다.",
		["Числа не могут быть меньше или равны 0. Минимальный уровень не может быть больше максимального"] = "숫자는 0보다 작거나 같을 수 없습니다. 최소 레벨은 최대 값보다 클 수 없습니다.",
		["Чтобы быть отфильтрованным, игрок должен соответствовать критериям ВСЕХ фильтров"] = "필터링하려면 플레이어가 모든 필터 기준을 충족해야합니다.",
		["tooltip"] = {
			["Автоматическое увеличение детализации поиска"] = "검색 세부 정보 자동 증가",
			["Введите диапазон уровней для фильтра.\nНапример: %s55%s:%s58%s\nбудут подходить только те игроки, уровень\nкоторых варьируется от %s55%s до %s58%s (включительно)"] = "필터의 레벨 범위를 입력하십시오.\n예:%s55%s:%s58%s\n 그 플레이어만 접근합니다.\n%s55%s에서 %s58%s까지 다양합니다.(포함)",
			["Введите максимальное количество последовательных\nгласных и согласных, которое может содержать имя игрока.\nНапример: %s3%s:%s5%s\nБудет означать, что игроки с более чем %s3%s гласными подряд\nили более %s5%s согласными подряд не будут добавлены в очередь."] = "연속되는 최대 자음과 자음의 수를 입력하십시오. 여기에는 플레이어의 이름이 포함될 수 있습니다.\n예:%s3%s:%s5%s\n 행에 %s3%s 이상의 모음이있는 플레이어가 \n%s5%s 이상의 행에 대기열에 추가되지 않습니다.",
			["Дополнительные настройки сканирования"] = "고급 스캔 설정",
			["Если имя игрока содержит введенную\nфразу, он не будет добавлен в очередь"] = "플레이어 이름에 입력 된 \nфразу이 있으면 대기열에 추가되지 않습니다.",
			["Запускать поиск в фоновом режиме"] = "백그라운드 검색 실행",
			["Количество уровней сканируемых за один раз"] = "한 번에 스캔 할 레벨 수",
			["Назначить клавишу для приглашения"] = "초대장에 키 지정",
			["Не отображать в чате отправляемые сообщения"] = "채팅에서 보낸 메시지 표시 안 함",
			["Не отображать в чате системные сообщения"] = "채팅에 시스템 메시지를 표시하지 마십시오.",
			["Не отображать в чате сообщения аддона"] = "부가 기능 채팅 메시지 표시 안 함",
			["Уровень, с которого начинается фильтр по классам"] = "클래스에 의해 필터가 시작되는 레벨입니다.",
			["Уровень, с которого начинается фильтр по расам"] = "클래스에 의해 필터가 시작되는 레벨",
		},
		["invType"] = {
			["Отправить сообщение и пригласить"] = "메시지 보내기 및 초대",
			["Только пригласить"] = "초대만",
			["Только сообщение"] = "메시지만",
		}
	},
	["SYSTEM"] = {
		["c-"] = "c-",
		["r-"] = "r-",
	}
}


FGI.L["koKR"] = L
