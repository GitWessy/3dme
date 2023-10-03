TriggerEvent("getCore",function(core)
    VorpCore = core
end)

RegisterServerEvent('3dme:shareDisplay')
AddEventHandler('3dme:shareDisplay', function(text, maxtime)
	TriggerClientEvent('3dme:triggerDisplay', -1, text, source, maxtime)

	if text ~= " " and text ~= nil and text ~= 0 then
		local _source = source
		local User = VorpCore.getUser(_source)
		local Character = User.getUsedCharacter
		local charidentifier = Character.charIdentifier
		local firstname = Character.firstname or ""
		local lastname = Character.lastname or ""
		local fullname = firstname.." "..lastname
		local steamname = GetPlayerName(_source)
		local steamidentifier = Character.identifier
		local discordtext = fullname.." ("..steamidentifier..") schreibt: ``"..text.."``"
		PerformHttpRequest("YOURDISCORDWEBHOOK", function(err, text, headers) end, 'POST', json.encode({content = discordtext}), { ['Content-Type'] = 'application/json' })
	end
end)
