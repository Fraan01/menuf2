local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}



local open						= false
local ESX						= nil
local PlayerData				= {}
local trabajoActual				= 'T'
local trabajoActualGrado		= 'J'
local trabajoActualGradoRaw		= 'B'

local ragdoll = false
local ragdol = true
local antiSpam = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
	
	while ESX.GetPlayerData() == nil do
		Citizen.Wait(10)
	end

  	PlayerData = ESX.GetPlayerData()
end)


 
 --- ============== NET EVENTS =================---------------
           -- Cargamos job
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	trabajoActual = PlayerData.job.label
	trabajoActualGrado = PlayerData.job.grade
	trabajoActualGradoRaw = PlayerData.job.grade_name
	--print("tu job loaded: ", PlayerData.job.name, "grado:", trabajoActualGrado)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	trabajoNombre = PlayerData.job.name
	trabajoActual = PlayerData.job.label
	trabajoActualGrado = PlayerData.job.grade
	trabajoActualGradoRaw = PlayerData.job.grade_name
	--print("tu nuevo job: ", PlayerData.job.name,"grado:", trabajoActualGrado)
	if trabajoActualGradoRaw ~= nil and trabajoActualGrado == 4 then
		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
			dineroSociedad = money
		end, trabajoNombre)
	end
	
end)

function setRagdoll(flag)
  ragdoll = flag
end

function setHandCuff(flag)
	handcuffed = flag
end
------------- TIRARSE AL SUELO ---------
RegisterNetEvent('ink_citizenmenu:ragdoll')
AddEventHandler('ink_citizenmenu:ragdoll', function()

	if ( ragdol ) then
		setRagdoll(true)
		ragdol = false
	else
		setRagdoll(false)
		ragdol = true
	end

end) 




 ----------==== MENUS ======--------------

function openMenu()
	---Menu principal
		local ped = GetPlayerPed(-1)
		local name = GetPlayerName(PlayerId())
		local id = GetPlayerServerId(PlayerId())
		local elements = {}
		if IsPedSittingInAnyVehicle(ped) and not IsPlayerDead(ped)then
			table.insert(elements, {label = 'Inventario', value = 'inventario'})
			table.insert(elements, {label = 'Información laboral', value = 'checkJob'})
			table.insert(elements, {label = 'Tarjeta de identificación', value = 'personal_info'})			
			table.insert(elements, {label = 'Limpiar Chat', value = 'clearChat'})
			table.insert(elements, {label = 'Historial de Facturas', value = 'billing_history'})
			table.insert(elements, {label = 'Facturas', value = 'billing'})	
			table.insert(elements, {label = 'Comprobar atracos disponibles', value = 'atracos'})
			table.insert(elements, {label = 'Personal disponible', value = 'trabajos'})
			table.insert(elements, {label = 'Locales disponibles', value = 'locales'})
			table.insert(elements, {label = 'Modo Cinematica', value = 'cinematica'})				
		else
			table.insert(elements, {label = 'Inventario', value = 'inventario'})
			table.insert(elements, {label = 'Información laboral', value = 'checkJob'})
			table.insert(elements, {label = 'Tarjeta de identificación', value = 'personal_info'})			
			table.insert(elements, {label = 'Limpiar chat', value = 'clearChat'})
			table.insert(elements, {label = 'Historial de facturas', value = 'billing_history'})	
			table.insert(elements, {label = 'Facturas', value = 'billing'})	
			table.insert(elements, {label = 'Comprobar atracos disponibles', value = 'atracos'})
			table.insert(elements, {label = 'Personal disponible', value = 'trabajos'})
			table.insert(elements, {label = 'Locales disponibles', value = 'locales'})
			table.insert(elements, {label = 'Modo cinematica', value = 'cinematica'})	
		end
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'citizen_menu',
		{
			title = name..' - ID: ' .. id,
			align    = 'bottom-right',
			elements = elements,
		},
		function(data, menu)
						local val = data.current.value
		
			if val == 'checkJob' then
				if trabajoActualGradoRaw ~= nil and trabajoActualGrado == 4 then
					ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
						dineroSociedad = money
					end, trabajoNombre)
				end

				local elements     = {}

				table.insert(elements, {label = 'Trabajo: ' .. PlayerData.job.label})
				table.insert(elements, {label = 'Rango: ' .. PlayerData.job.grade_label})
				if trabajoActualGrado == 4 then
					table.insert(elements, {label = 'Dinero de tu sociedad: ' .. dineroSociedad})
				end
					
				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job',
				{
				title    = 'Información laboral',
				align    = 'bottom-right',
				elements = elements,
				}, function(data1, menu1)
					
					--print('test submenu')
				end,
				function(data1, menu1)
					menu1.close()	
				end)
			elseif val == 'personal_info' then
				TriggerEvent('st:openMenu')			
			elseif val == 'clearChat' then
				ExecuteCommand("clear")
			elseif val == 'cinematica' then
				ExecuteCommand('cinematica')
			elseif val == 'billing' then
				ExecuteCommand('showbills')
			elseif val == 'desmontar' then
				TriggerEvent('esx_st:sacar')
			elseif val == 'inventario' then
				ESX.ShowInventory()
			elseif val == 'atracos' then
				TriggerEvent('st:atracos')
			elseif val == 'trabajos' then
				TriggerEvent('st:trabajos')
			elseif val == 'billing_history' then
				TriggerEvent('st:billing_history')
			elseif val == 'locales' then
				TriggerEvent('st:locales')
			else
				ESX.ShowNotification('~r~ERROR:~s~ Algo ha fallado')
			end

		end,
		function(data, menu)
			menu.close()
	end)
						
end

function openlicenciasMenu2()
  ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'personal_info',
	{
		title    = 'Menú de Identidad',
		align    = 'bottom-right',		
		elements = {
			{label = 'Ver tu DNI', value = 'checkID'},
			{label = 'Mostrar tu DNI', value = 'showID'},
			{label = 'Ver tu licencia de conducir', value = 'checkDriver'},
			{label = 'Mostrar licencia de conducir', value = 'showDriver'},
			{label = 'Ver tu licencia de armas', value = 'checkWeapon'},
			{label = 'Mostrar licencia de armas', value = 'showWeapon'}
			,
		}
	},
	function(data, menu)
		local val = data.current.value
		
		if val == 'checkID' then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
		elseif val == 'checkDriver' then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
		elseif val == 'checkWeapon' then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
		else
			local player, distance = ESX.Game.GetClosestPlayer()
			
			if distance ~= -1 and distance <= 3.0 then
				if val == 'showID' then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
				elseif val == 'showDriver' then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
				elseif val == 'showWeapon' then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'weapon')
				end
			else
				ESX.ShowNotification(_U('no_players'))
			end
		end
	end,
	function(data, menu)
		menu.close()
	end
)
end



AddEventHandler('st:openMenu', function()
	openlicenciasMenu2()
end)


function openAtracosMenu()
	ESX.TriggerServerCallback('st:policiasconectados', function(CopsConnected)

			local elements = {}

			if CopsConnected == 0 or CopsConnected == 1 then
				table.insert(elements, {label = 'Badulaque: <span style="color: red; font-weight: bold;">NO</span>'})
				table.insert(elements, {label = 'Licorerías: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Badulaque: <span style="color: green; font-weight: bold;">SI</span>'})
				table.insert(elements, {label = 'Licorerías: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if CopsConnected < 2 then
				table.insert(elements, {label = 'Sucursales Bancarias: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Sucursales Bancarias: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if CopsConnected < 4 then
				table.insert(elements, {label = 'Joyería: <span style="color: red; font-weight: bold;">NO</span>'})
				table.insert(elements, {label = 'Banco Central: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Joyería: <span style="color: green; font-weight: bold;">SI</span>'})
				table.insert(elements, {label = 'Banco Central: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if CopsConnected < 2 then
				table.insert(elements, {label = 'Atraco a Civil: <span style="color: red; font-weight: bold;">NO</span>'})
				table.insert(elements, {label = 'Secuestro a Civil: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Atraco a Civil: <span style="color: green; font-weight: bold;">SI</span>'})
				table.insert(elements, {label = 'Secuestro a Civil: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if CopsConnected < 6 then
				table.insert(elements, {label = 'Secuestro a Policia: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Secuestro a Policia: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if CopsConnected < 5 then
				table.insert(elements, {label = 'Secuestro a Entidad del Estado: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Secuestro a Entidad del Estado: <span style="color: green; font-weight: bold;">SI</span>'})
			end


			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'atracos_menu',
				{
					title    = 'Atracos Disponibles',
					align    = 'bottom-right',		
					elements = elements,
				},
				function(data, menu)
			
			
				end,
			function(data, menu)
				menu.close()
			end
			)
	end)
end

function openAtracosMenu()
	ESX.TriggerServerCallback('st:policiasconectados', function(CopsConnected)

			local elements = {}

			if CopsConnected == 0 or CopsConnected == 1 then
				table.insert(elements, {label = 'Badulaque: <span style="color: red; font-weight: bold;">NO</span>'})
				table.insert(elements, {label = 'Licorerías: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Badulaque: <span style="color: green; font-weight: bold;">SI</span>'})
				table.insert(elements, {label = 'Licorerías: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if CopsConnected < 2 then
				table.insert(elements, {label = 'Sucursales Bancarias: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Sucursales Bancarias: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if CopsConnected < 4 then
				table.insert(elements, {label = 'Joyería: <span style="color: red; font-weight: bold;">NO</span>'})
				table.insert(elements, {label = 'Banco Central: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Joyería: <span style="color: green; font-weight: bold;">SI</span>'})
				table.insert(elements, {label = 'Banco Central: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if CopsConnected < 2 then
				table.insert(elements, {label = 'Atraco a Civil: <span style="color: red; font-weight: bold;">NO</span>'})
				table.insert(elements, {label = 'Secuestro a Civil: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Atraco a Civil: <span style="color: green; font-weight: bold;">SI</span>'})
				table.insert(elements, {label = 'Secuestro a Civil: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if CopsConnected < 6 then
				table.insert(elements, {label = 'Secuestro a Policia: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Secuestro a Policia: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if CopsConnected < 5 then
				table.insert(elements, {label = 'Secuestro a Entidad del Estado: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Secuestro a Entidad del Estado: <span style="color: green; font-weight: bold;">SI</span>'})
			end


			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'atracos_menu',
				{
					title    = 'Atracos Disponibles',
					align    = 'bottom-right',		
					elements = elements,
				},
				function(data, menu)
			
			
				end,
			function(data, menu)
				menu.close()
			end
			)
	end)
end

AddEventHandler('st:atracos', function()
	openAtracosMenu()
end)

function openTrabajosMenu()
	ESX.TriggerServerCallback('st:policiasconectados', function(CopsConnected, EmsConnected, MechanicConnected, TaxiConnected)

			local elements = {}

			if CopsConnected < 1 then
				table.insert(elements, {label = 'Policía: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Policía: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if EmsConnected < 1 then
				table.insert(elements, {label = 'EMS: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'EMS: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if MechanicConnected < 1 then
				table.insert(elements, {label = 'Mecánico: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Mecánico: <span style="color: green; font-weight: bold;">SI</span>'})
			end

			if TaxiConnected < 1 then
				table.insert(elements, {label = 'Taxi: <span style="color: red; font-weight: bold;">NO</span>'})
			else
				table.insert(elements, {label = 'Taxi: <span style="color: green; font-weight: bold;">SI</span>'})
			end




			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'trabajos_menu',
				{
					title    = 'Personal Disponible',
					align    = 'bottom-right',		
					elements = elements,
				},
				function(data, menu)
			
			
				end,
			function(data, menu)
				menu.close()
			end
			)
	end)
end

AddEventHandler('st:trabajos', function()
	openTrabajosMenu()
end)



function ShowBillsMenu()

	ESX.TriggerServerCallback('esx_billing:getBills', function(bills)

		ESX.UI.Menu.CloseAll()

		local elements = {}

		for i=1, #bills, 1 do
			table.insert(elements, {label = bills[i].label .. ' - <span style="color: red;">$' .. bills[i].amount .. '</span>', value = bills[i].id})
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'billing',
			{
				title    = _U('invoices'),
				align    = 'bottom-right',
				elements = elements
			},
			function(data, menu)

				menu.close()

				local billId = data.current.value

				ESX.TriggerServerCallback('esx_billing:payBill', function()
					ShowBillsMenu()
				end, billId)

			end,
			function(data, menu)
				menu.close()
			end
		)

	end)

end

function ShowHistoryBillsMenu()

	ESX.TriggerServerCallback('esx_billing:getHistoryBills', function(bills)

		ESX.UI.Menu.CloseAll()

		local elements = {}

		for i=1, #bills, 1 do
			if bills[i].target == 'society_police' then
				table.insert(elements, {label = '<span style="color: blue; font-weight: bold";> Policía Nacional </span> - ' .. bills[i].label .. ' - <span style="color: red; font-weight: bold";">' .. bills[i].amount .. '€</span>', value = bills[i].id})
			elseif bills[i].target == 'society_mechanic' then
				table.insert(elements, {label = '<span style="color: orange; font-weight: bold";> Mecánico Cruzcampo </span> - ' .. bills[i].label .. ' - <span style="color: red; font-weight: bold";">' .. bills[i].amount .. '€</span>', value = bills[i].id})
			elseif bills[i].target == 'society_taxi' then
				table.insert(elements, {label = '<span style="color: yellow; font-weight: bold";> Taxi </span> - ' .. bills[i].label .. ' - <span style="color: red; font-weight: bold";">' .. bills[i].amount .. '€</span>', value = bills[i].id})
			end
		end

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'billing_history',
			{
				title    = 'Historial de Facturas',
				align    = 'bottom-right',
				elements = elements
			},
			function(data, menu)


			end,
			function(data, menu)
				menu.close()
			end
		)

	end)

end

AddEventHandler('st:billing_history', function()
	ShowHistoryBillsMenu()
end)

function openLocalesMenu()
	ESX.TriggerServerCallback('st:trabajosconectados', function(TequilaConnected, YellowJackConnected, GreenConnected, CyberConnected, VanillaConnected, BahamasConnected)

			local elements = {}

			if BahamasConnected < 1 then
				table.insert(elements, {label = 'Bahamas: <span style="color: red; font-weight: bold";">CERRADO</span>'})
			else
				table.insert(elements, {label = 'Bahamas: <span style="color: green; font-weight: bold";">ABIERTO</span>'})
			end

			if GreenConnected < 1 then
				table.insert(elements, {label = 'Coffee Shop: <span style="color: red; font-weight: bold";">CERRADO</span>'})
			else
				table.insert(elements, {label = 'Coffee Shop: <span style="color: green; font-weight: bold";">ABIERTO</span>'})
			end

			if CyberConnected < 1 then
				table.insert(elements, {label = 'Cyber: <span style="color: red; font-weight: bold";">CERRADO</span>'})
			else
				table.insert(elements, {label = 'Cyber: <span style="color: green; font-weight: bold";">ABIERTO</span>'})
			end

			if TequilaConnected < 1 then
				table.insert(elements, {label = 'Tequi-la-la: <span style="color: red; font-weight: bold";">CERRADO</span>'})
			else
				table.insert(elements, {label = 'Tequi-la-la: <span style="color: green; font-weight: bold";">ABIERTO</span>'})
			end

			if VanillaConnected < 1 then
				table.insert(elements, {label = 'StarBlue: <span style="color: red; font-weight: bold";">CERRADO</span>'})
			else
				table.insert(elements, {label = 'StarBlue: <span style="color: green; font-weight: bold";">ABIERTO</span>'})
			end

			if YellowJackConnected < 1 then
				table.insert(elements, {label = 'Yellow Jack: <span style="color: red; font-weight: bold";">CERRADO</span>'})
			else
				table.insert(elements, {label = 'Yellow Jack: <span style="color: green; font-weight: bold";">ABIERTO</span>'})
			end

			

			





			ESX.UI.Menu.Open(
				'default', GetCurrentResourceName(), 'locales',
				{
					title    = 'Locales disponibles',
					align    = 'bottom-right',		
					elements = elements,
				},
				function(data, menu)
			
			
				end,
			function(data, menu)
				menu.close()
			end
			)
	end)
end


AddEventHandler('st:locales', function()
	openLocalesMenu()
end)

-----------------
-- Key events
Citizen.CreateThread(function()
   while true do
		Citizen.Wait(0)

		if IsControlJustReleased(0, Keys['F2']) and IsInputDisabled(0) then
			openMenu()
		end

		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
            SendNUIMessage({
                action = "close"
            })
            open = false
        end
	end
end)






Citizen.CreateThread(function() 

	while true do 
		Citizen.Wait(100)
		if antiSpam == true then
			Citizen.Wait(300)
			antiSpam = false 
		end
	end
end)