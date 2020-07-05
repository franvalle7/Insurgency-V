
local captureZone = {
    {label = "Silo", pos = vector3(2901.66, 4383.41, 50.35), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Crossroad", pos = vector3(2498.99, 4118.77, 37.88), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Color montain", pos = vector3(2482.08, 3757.56, 41.26), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Sandy Shores", pos = vector3(1799.86, 3734.57, 33.29), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Yellow Jack", pos = vector3(1996.03, 3064.16, 4705), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Mine", pos = vector3(2683.63, 2827.97, 40.27), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Montain house", pos = vector3(1737.86, 3038.64, 61.29), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Fuel farm", pos = vector3(634.25, 2908.58, 39.97), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Church", pos = vector3(-329.73, 2823.63, 58.04), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Vacation house", pos = vector3(-258.06, 2195.35, 129.82), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Deposit", pos = vector3(192.47, 2753.58, 43.43), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Camp", pos = vector3(67.5, 3708.79, 39.75), blip = nil, blip2 = nil, team = "Neutral"},
    {label = "Liquor market", pos = vector3(917.51, 3622.35, 32.47), blip = nil, blip2 = nil, team = "Neutral"},
}


local BlipsInfo = {
    ["army"] = {sprite = 590, color = 77},
    ["resistance"] = {sprite = 543, color = 49},
    ["Neutral"] = {sprite = 464, color = 55},
}


RegisterNetEvent("V:SyncBlips")
AddEventHandler("V:SyncBlips", function(blips)
    for k,v in pairs(blips) do
        captureZone[k].team = blips[k].team

        RemoveBlip(captureZone[k].blip)
        RemoveBlip(captureZone[k].blip2)
    
        captureZone[k].blip = AddBlipForCoord(captureZone[k].pos)
        SetBlipSprite(captureZone[k].blip, BlipsInfo[blips[k].team].sprite)
        SetBlipColour(captureZone[k].blip, BlipsInfo[blips[k].team].color)
        SetBlipScale(captureZone[k].blip, 1.0)
    
    
        captureZone[k].blip2 = AddBlipForRadius(captureZone[k].pos, 350.0)
        SetBlipColour(captureZone[k].blip2, BlipsInfo[blips[k].team].color)
        SetBlipAlpha(captureZone[k].blip2, 170)  
    end
end)

RegisterNetEvent("V:ZoneCaptured")
AddEventHandler("V:ZoneCaptured", function(label, team, id)
    SetAudioFlag("LoadMPData", true)
    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
    PlaySoundFrontend(-1, "Enemy_Capture_Start", "GTAO_Magnate_Yacht_Attack_Soundset", 1)
    ShowPopupWarning("Zone captured!", "The ~b~"..team.."~s~ has captured ~b~"..label.."~s~ zone.", 5)

    RemoveBlip(captureZone[id].blip)
    RemoveBlip(captureZone[id].blip2)

    captureZone[id].blip = AddBlipForCoord(captureZone[id].pos)
    SetBlipSprite(captureZone[id].blip, BlipsInfo[team].sprite)
    SetBlipColour(captureZone[id].blip, BlipsInfo[team].color)
    SetBlipScale(captureZone[id].blip, 1.0)


    captureZone[id].blip2 = AddBlipForRadius(captureZone[id].pos, 350.0)
    SetBlipColour(captureZone[id].blip2, BlipsInfo[team].color)
    SetBlipAlpha(captureZone[id].blip2, 170)

    captureZone[id].team = team
end)




local InCapture = false
Citizen.CreateThread(function()

    while player == nil do Wait(1) end
    while player.camp == nil do Wait(1) end
    for k,v in pairs(captureZone) do
        captureZone[k].blip = AddBlipForCoord(captureZone[k].pos)
        SetBlipSprite(captureZone[k].blip, 464)
        SetBlipColour(captureZone[k].blip, 55)
        SetBlipScale(captureZone[k].blip, 1.0)
    
        captureZone[k].blip2 = AddBlipForRadius(captureZone[k].pos, 350.0)
        SetBlipColour(captureZone[k].blip2, 55)
        SetBlipAlpha(captureZone[k].blip2, 170)
    end

    TriggerServerEvent("V:RequestBlipSync")
    while true do
        local IsCaptureZone = false
        if not InCapture then
            for k,v in pairs(captureZone) do
                if captureZone[k].team ~= player.camp then
                    if GetDistanceBetweenCoords(v.pos, player.coords, false) < 50.0 then
                        InCapture = true
                        StartCapture(k, v.pos)
                        break
                    end
                end
            end
        end
        Wait(500)
    end
end)

local possibleMusic = {
    "https://www.youtube.com/watch?v=mLyzt8zlG-c",
    "https://www.youtube.com/watch?v=U-Az2g0nQeA",
    "https://www.youtube.com/watch?v=y9nbTiI2r8M",
    "https://www.youtube.com/watch?v=sj1ymUTzfvY",
    "https://www.youtube.com/watch?v=k61-CexDaDY",
    "https://www.youtube.com/watch?v=30fUOnV4WPc",
}
function StartCapture(id, pos)
    
    local id = id

    TriggerEvent("xsound:stateSound", "play", {
        soundId = "capture", 
        url = possibleMusic[math.random(1,#possibleMusic)], 
        volume = 0.2, 
        loop = true
    })

    Citizen.CreateThread(function()
        while InCapture do
            RageUI.Text({message = "Capture de zone en cours ..."})
            if GetDistanceBetweenCoords(pos, player.coords, false) > 50.0 then
                InCapture = false
                TriggerEvent("xsound:stateSound", "destroy", {soundId = "capture", })
            end

            if IsEntityDead(player.ped) then
                InCapture = false
                TriggerEvent("xsound:stateSound", "destroy", {soundId = "capture", })
            end
            Wait(1)
        end
    end)

    local oldTime = GetGameTimer()
    Citizen.CreateThread(function()
        while InCapture do
            if oldTime + 30*1000 < GetGameTimer() then
                oldTime = GetGameTimer()

                TriggerServerEvent("V:CapturePoint", id, player.camp)
                TriggerEvent("xsound:stateSound", "destroy", {soundId = "capture", })
                Wait(5000)
                InCapture = false
            end

            Wait(0)
        end
    end)
    
end