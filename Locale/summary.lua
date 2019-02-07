local size = FGI.L.settings.size

FGI.L.race = FGI.L.race[UnitFactionGroup("player")]


size.mainButtonsGRP = size.startScan + size.chooseInvites + size.settingsBtn
size.mainCheckBoxGRP = math.max(size.deepSearch, size.normalSearch, size.smartSearch, size.backgroundRun, size.enableFilters)
size.searchRangeGRP = math.max(size.lvlRange + size.raceFilterStart, size.searchInterval + size.classFilterStart)+30
size.settingsCheckBoxGRP = math.max(size.addonMSG, size.systemMSG, size.sendMSG, size.minimapButton)
size.settingsButtonsGRP = size.filters + size.keyBind + size.setMSG
size.raceShift = math.max(size.Ignore, size.DeathKnight, size.DemonHunter, size.Druid, size.Hunter, size.Mage, size.Monk, size.Paladin, size.Priest, size.Rogue, size.Shaman, size.Warlock, size.Warrior)
size.raceShift = size.raceShift - size.classLabel + 20
size.filterNameShift = {}
for k,v in pairs(FGI.L.race) do 
table.insert(size.filterNameShift, size[k]) 
end 
size.filterNameShift = math.max(unpack(size.filterNameShift)) - size.raceLabel + 20
size.filtersEdit = math.max(size.filterNameLabel, size.excludeNameLabel, size.lvlRangeLabel, size.excludeRepeatLabel)