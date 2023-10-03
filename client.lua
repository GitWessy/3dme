local time = 2000
local displaying = {}

RegisterCommand('me', function(source, args)
    local myid = GetPlayerServerId(GetPlayerIndex())
    --print(myid)
    displaying[myid] = false
    local text = ''
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' '
    TriggerServerEvent('3dme:shareDisplay', text, time)
end)

--[[RegisterCommand('me2', function(source, args)
    displaying = false
    local text = ''
    local maxtime = args[1] * 1000
    for i = 2,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' '
    TriggerServerEvent('3dme:shareDisplay', text, maxtime)
end)]]

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source, maxtime)
    displaying[source] = false    
    Display(source, text, maxtime)
end)

function Display(source, text, maxtime)
    local _source = source
    local mePlayer = GetPlayerFromServerId(_source)
    local resttime = maxtime

    if chatMessage then
        local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
        local coords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist2(coordsMe, coords)
        if dist < 10 then
            TriggerEvent('chat:addMessage', {
                color = { color.r, color.g, color.b },
                multiline = true,
                args = { text}
            })
        end
    end

    Citizen.CreateThread(function()
        displaying[source] = true
        while displaying[_source] do
            Citizen.Wait(0)
            resttime = resttime - 1
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist2(coordsMe, coords)
            if dist < 40 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+1, text)
            end
            if resttime < 1 then
                displaying[source] = false
            end
        end
    end)
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())  
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if onScreen then
    	SetTextScale(0.30, 0.30)
  		SetTextFontForCurrentCommand(25)
    	SetTextColor(255, 255, 255, 215)
    	SetTextCentre(1)
    	DisplayText(str,_x,_y)
    	local factor = (string.len(text)) / 210
    	DrawSprite("policies_menu", "selection_box_bg_1b", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 35, 35, 35, 190, 0)
    	--DrawSprite("feeds", "toast_bg", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 100, 1, 1, 190, 0)
    end
end