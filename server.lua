local ESX = nil
-- ESX
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('st:policiasconectados', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	local xPlayers = ESX.GetPlayers()

	CopsConnected = 0
	EmsConnected = 0
	MechanicConnected = 0
	TaxiConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			CopsConnected = CopsConnected + 1
		elseif xPlayer.job.name == 'ambulance' then 
			EmsConnected = EmsConnected + 1
		elseif xPlayer.job.name == 'mechanic' then 
			MechanicConnected = MechanicConnected + 1
		elseif xPlayer.job.name == 'taxi' then 
			TaxiConnected = TaxiConnected + 1
		end
	end

	cb(CopsConnected, EmsConnected, MechanicConnected, TaxiConnected)
end)

ESX.RegisterServerCallback('st:trabajosconectados', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	local xPlayers = ESX.GetPlayers()

	TequilaConnected = 0
	YellowJackConnected = 0
	GreenConnected = 0
	CyberConnected = 0
	VanillaConnected = 0
	BahamasConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'tequilala2' then
			TequilaConnected = TequilaConnected + 1
		elseif xPlayer.job.name == 'yellowjack2' then
			YellowJackConnected = YellowJackConnected + 1
		elseif xPlayer.job.name == 'radio2' then
			GreenConnected = GreenConnected + 1
		elseif xPlayer.job.name == 'cyber2' then
			CyberConnected = CyberConnected + 1
		elseif xPlayer.job.name == 'unicorn2' then
			VanillaConnected = VanillaConnected + 1
		elseif xPlayer.job.name == 'bahamas2' then
			BahamasConnected = BahamasConnected + 1
		end
	end

	cb(TequilaConnected, YellowJackConnected, GreenConnected, CyberConnected, VanillaConnected, BahamasConnected)
end)

ESX.RegisterServerCallback('ink_citizenmenu:getDeathStatusTarget', function(source,cb,closestPlayerPedId)
	local src = source
	
	local identifier = GetPlayerIdentifiers(closestPlayerPedId)[1]
	local identifiermio = GetPlayerIdentifiers(src)[1]

	--print("dentro de trigger, id source",identifiermio,"id target", identifier)

	MySQL.Async.fetchScalar('SELECT is_dead FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(isDead)
		if isDead then
			--print('ink_citizenmenu: '..identifiermio.. ' comprobando estado a: ' ..identifier..' muerto?: ' ..tostring(isDead))

		end
		
		cb(isDead)
	end)
end)




