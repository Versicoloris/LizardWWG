-- LizardWWG

BINDING_HEADER_LizardWWG = "LizardWWG"
BINDING_NAME_LIZARDWWG_OPENMAP = "Open warp map"

local zoneZoom = {

-- Eastern Kingdoms
["Alterac Mountains"]={2,1},
["Arathi Highlands"]={2,2},
["Badlands"]={2,3},
["Blasted Lands"]={2,4},
["Burning Steppes"]={2,5},
["Deadwind Pass"]={2,6},
["Dun Morogh"]={2,7},
["Duskwood"]={2,8},
["Eastern Plaguelands"]={2,9},
["Elwynn Forest"]={2,10},
["Eversong Woods"]={2,11},
["Ghostlands"]={2,12},
["Hillsbrad Foothills"]={2,13},
["Ironforge"]={2,14},
["Isle of Quel'Danas"]={2,15},
["Loch Modan"]={2,16},
["Redridge Mountains"]={2,17},
["Searing Gorge"]={2,18},
["Silvermoon City"]={2,19},
["Silverpine Forest"]={2,20},
["Stormwind City"]={2,21},
["Stranglethorn Vale"]={2,22},
["Swamp of Sorrows"]={2,23},
["The Hinterlands"]={2,24},
["Tirisfal Glades"]={2,25},
["Undercity"]={2,26},
["Western Plaguelands"]={2,27},
["Westfall"]={2,28},
["Wetlands"]={2,29},

-- Kalimdor
["Ashenvale"]={1,1},
["Azshara"]={1,2},
["Azuremyst Isle"]={1,3},
["Bloodmyst Isle"]={1,4},
["Darkshore"]={1,5},
["Darnassus"]={1,6},
["Desolace"]={1,7},
["Durotar"]={1,8},
["Dustwallow Marsh"]={1,9},
["Felwood"]={1,10},
["Feralas"]={1,11},
["Moonglade"]={1,12},
["Mulgore"]={1,13},
["Orgrimmar"]={1,14},
["Silithus"]={1,15},
["Stonetalon Mountains"]={1,16},
["Tanaris"]={1,17},
["Teldrassil"]={1,18},
["The Barrens"]={1,19},
["The Exodar"]={1,20},
["Thousand Needles"]={1,21},
["Thunder Bluff"]={1,22},
["Un'Goro Crater"]={1,23},
["Winterspring"]={1,24},

-- Outland
["Blade's Edge Mountains"]={3,1},
["Hellfire Peninsula"]={3,2},
["Nagrand"]={3,3},
["Netherstorm"]={3,4},
["Shadowmoon Valley"]={3,5},
["Shattrath City"]={3,6},
["Terokkar Forest"]={3,7},
["Zangarmarsh"]={3,8},

-- Northrend
["Borean Tundra"]={4,1},
["Crystalsong Forest"]={4,2},
["Dalaran"]={4,3},
["Dragonblight"]={4,4},
["Grizzly Hills"]={4,5},
["Howling Fjord"]={4,6},
["Hrothgar's Landing"]={4,7},
["Icecrown"]={4,8},
["Sholazar Basin"]={4,9},
["The Storm Peaks"]={4,10},
["Wintergrasp"]={4,11},
["Zul'Drak"]={4,12},

}

local function FindZone(text)

    if not text then return end
    text = text:gsub("[%c]","")

    for zone,data in pairs(zoneZoom) do
        if text:find(zone) then
            return zone,data
        end
    end

end


local function OpenMap(data)

    ShowUIPanel(WorldMapFrame)
    SetMapZoom(data[1])
    SetMapZoom(data[1],data[2])

end


function LizardWWG_OpenMap()

    if not TPortFrame or not TPortFrame:IsVisible() then return end

    local focus = GetMouseFocus()
    if not focus then return end

    local name = focus:GetName()
    if not name or not name:find("TPortFrame%-Line") then return end

    for _,region in ipairs({focus:GetRegions()}) do

        if region.GetText then

            local text = region:GetText()

            if text then
                local zone,data = FindZone(text)

                if data then
                    OpenMap(data)
                end

                return
            end

        end

    end

end


-- Right-click warp → open map

local function HookWarpButtons()

    if not TPortFrame or not TPortFrame.ScrollFrame1 then return end
    if not TPortFrame.ScrollFrame1.Content then return end

    local content = TPortFrame.ScrollFrame1.Content
    local children = {content:GetChildren()}

    for _,child in ipairs(children) do

        local name = child:GetName()

        if name and name:find("TPortFrame%-Line") and name:find("%-Bar") then

            if not child.LizardHooked then

                child:RegisterForClicks("LeftButtonUp","RightButtonUp")

                child:HookScript("OnMouseUp", function(self,button)

                    if button ~= "RightButton" then return end

                    for _,region in ipairs({self:GetRegions()}) do
                        if region.GetText then

                            local text = region:GetText()

                            if text then
                                local zone,data = FindZone(text)
                                if data then
                                    OpenMap(data)
                                end
                                return
                            end

                        end
                    end

                end)

                child.LizardHooked = true

            end

        end

    end

end


local frame = CreateFrame("Frame")

frame:SetScript("OnUpdate",function()

    if TPortFrame and TPortFrame:IsVisible() then
        HookWarpButtons()
    end

end)