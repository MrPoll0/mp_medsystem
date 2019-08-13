ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
 
local job = nil
AddEventHandler('playerSpawned', function(spawn)
  TriggerServerEvent('medSys:getJob')
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    TriggerServerEvent('medSys:getJob')
end)
TriggerServerEvent('medSys:getJob')
RegisterNetEvent('medSys:setJob')
AddEventHandler('medSys:setJob',function(jobu)
  job = jobu
end)

function clear()
	SetEntityHealth(GetPlayerPed(-1), 200)
	SetPedArmour(GetPlayerPed(-1), 100)
    bleeding = 0
    bones = {
	  Torso = {dmg = 0, gravedad = 0},
	  Cabeza = {dmg = 0, gravedad = 0},
	  Pizq = {dmg = 0, gravedad = 0},
	  Pder = {dmg = 0, gravedad = 0},
	  Bizq = {dmg = 0, gravedad = 0}, 
	  Bder = {dmg = 0, gravedad = 0}
	  }
    toxicity = 0 
    health = GetEntityHealth(GetPlayerPed(-1))
    armour = GetPedArmour(GetPlayerPed(-1))
    dead = false
    inconsciente = false
    Update()
    ClearTimecycleModifier()
    ResetPedMovementClipset(GetPlayerPed(-1), 0) 
    SetPedMoveRateOverride(PlayerId(), 1.0)
    SendNUIMessage({type = "change", part = "Cabeza", gravedad = "white", type1 = "0"})
    SendNUIMessage({type = "change", part = "Torso", gravedad = "white", type1 = "0"})
    SendNUIMessage({type = "change", part = "Pizq", gravedad = "white", type1 = "0"})
    SendNUIMessage({type = "change", part = "Pder", gravedad = "white", type1 = "0"})
    SendNUIMessage({type = "change", part = "Bizq", gravedad = "white", type1 = "0"})
    SendNUIMessage({type = "change", part = "Bder", gravedad = "white", type1 = "0"})
    StopScreenEffect('DeathFailOut',  0,  false)
    ClearTimecycleModifier()
	ResetPedMovementClipset(GetPlayerPed(-1), 0) 
	SetPedMoveRateOverride(PlayerId(), 1.0)
	Citizen.Wait(5000)
	inconsciente = false
    timer = false
    StopScreenEffect('DeathFailOut',  0,  false)
    if health <= 0 then
    	TriggerEvent('esx_ambulancejob:revive')
    end
end

TriggerServerEvent('medSys:init', 0)

RegisterNetEvent('medSys:loading')
AddEventHandler('medSys:loading', function()
	SetPlayerInvincible(PlayerId(), true)
	Citizen.Wait(100000)
	SetPlayerInvincible(PlayerId(), false)
	TriggerServerEvent('medSys:init', 1)
	clear()
	if inconsciente == true or health ~= 200 then 
		clear()
	end
	Citizen.Wait(60000)
	clear()
end)

RegisterNetEvent('medSys:clear')
AddEventHandler('medSys:clear', function()  --  <-- skinchanger
	clear()
end)

--======================================================================
--===============================VARIABLES==============================
--======================================================================

local health = GetEntityHealth(GetPlayerPed(-1))
local armour = GetPedArmour(GetPlayerPed(-1))
local bleeding = 0 
local toxicity = 0
local dead = false 
local bone = GetPedLastDamageBone(GetPlayerPed(-1))
local state = ''
local second = 1000
local minute = 60 * second
local inconsciente = false
local a = false
local b = false
local tick
local timer = false
local allHealth = (math.max(health-100,0)/2) + (armour/2)
local coords = GetEntityCoords(PlayerPedId())

--local FirstSpawn = false
--local pulse = 80

local bones = {
  Torso = {dmg = 0, gravedad = 0},
  Cabeza = {dmg = 0, gravedad = 0},
  Pizq = {dmg = 0, gravedad = 0},
  Pder = {dmg = 0, gravedad = 0},
  Bizq = {dmg = 0, gravedad = 0}, 
  Bder = {dmg = 0, gravedad = 0}
}  

StopScreenEffect('DeathFailOut',  0,  false)
ClearTimecycleModifier()
ResetPedMovementClipset(GetPlayerPed(-1), 0) 
SetPedMoveRateOverride(PlayerId(), 1.0)
SetPedArmour(GetPlayerPed(-1), 100)

--======================================================================
--===================================NUI================================
--======================================================================

local guiEnabled = false
local guiEnableded = false

RegisterNetEvent('medSys:on')
AddEventHandler('medSys:on',function()
    SendNUIMessage({type = "status", health = allHealth, bleeding = bleeding})
    SendNUIMessage({type = "change", part = "Cabeza", gravedad = "white", type1 = "0"})
    SendNUIMessage({type = "change", part = "Torso", gravedad = "white", type1 = "0"})
    SendNUIMessage({type = "change", part = "Pizq", gravedad = "white", type1 = "0"})
    SendNUIMessage({type = "change", part = "Pder", gravedad = "white", type1 = "0"})
    SendNUIMessage({type = "change", part = "Bizq", gravedad = "white", type1 = "0"})
    SendNUIMessage({type = "change", part = "Bder", gravedad = "white", type1 = "0"})
    if bones.Cabeza.gravedad == 0 then 
        SendNUIMessage({type = "change", part = "Cabeza", gravedad = "white", type1 = "1"})
    end
    if bones.Torso.gravedad == 0 then 
      SendNUIMessage({type = "change", part = "Torso", gravedad = "white", type1 = "1"})
    end
    if bones.Bizq.gravedad == 0 then 
      SendNUIMessage({type = "change", part = "Bizq", gravedad = "white", type1 = "1"})
    end
    if bones.Bder.gravedad == 0 then 
      SendNUIMessage({type = "change", part = "Bder", gravedad = "white", type1 = "1"})
    end
    if bones.Pizq.gravedad == 0 then 
      SendNUIMessage({type = "change", part = "Pizq", gravedad = "white", type1 = "1"})
    end
    if bones.Pder.gravedad == 0 then 
      SendNUIMessage({type = "change", part = "Pder", gravedad = "white", type1 = "1"})
    end  

    if bones.Cabeza.gravedad == 1 then 
      SendNUIMessage({type = "change", part = "Cabeza", gravedad = "yellow", type1 = "1"})
    end
    if bones.Torso.gravedad == 1 then 
      SendNUIMessage({type = "change", part = "Torso", gravedad = "yellow", type1 = "1"})
    end
    if bones.Bizq.gravedad == 1 then 
      SendNUIMessage({type = "change", part = "Bizq", gravedad = "yellow", type1 = "1"})
    end
    if bones.Bder.gravedad == 1 then 
      SendNUIMessage({type = "change", part = "Bder", gravedad = "yellow", type1 = "1"})
    end
    if bones.Pizq.gravedad == 1 then 
      SendNUIMessage({type = "change", part = "Pizq", gravedad = "yellow", type1 = "1"})
    end
    if bones.Pder.gravedad == 1 then 
      SendNUIMessage({type = "change", part = "Pder", gravedad = "yellow", type1 = "1"})
    end  

    if bones.Cabeza.gravedad == 2 then 
      SendNUIMessage({type = "change", part = "Cabeza", gravedad = "orange", type1 = "1"})
    end
    if bones.Torso.gravedad == 2 then 
      SendNUIMessage({type = "change", part = "Torso", gravedad = "orange", type1 = "1"})
    end
    if bones.Bizq.gravedad == 2 then 
      SendNUIMessage({type = "change", part = "Bizq", gravedad = "orange", type1 = "1"})
    elseif bones.Bder.gravedad == 2 then 
      SendNUIMessage({type = "change", part = "Bder", gravedad = "orange", type1 = "1"})
    end
    if bones.Pizq.gravedad == 2 then 
      SendNUIMessage({type = "change", part = "Pizq", gravedad = "orange", type1 = "1"})
    end
    if bones.Pder.gravedad == 2 then 
      SendNUIMessage({type = "change", part = "Pder", gravedad = "orange", type1 = "1"})
    end 

    if bones.Cabeza.gravedad == 3 then 
      SendNUIMessage({type = "change", part = "Cabeza", gravedad = "red", type1 = "1"})
    end
    if bones.Torso.gravedad == 3 then 
      SendNUIMessage({type = "change", part = "Torso", gravedad = "red", type1 = "1"})
    end
    if bones.Bizq.gravedad == 3 then 
      SendNUIMessage({type = "change", part = "Bizq", gravedad = "red", type1 = "1"})
    end
    if bones.Bder.gravedad == 3 then 
      SendNUIMessage({type = "change", part = "Bder", gravedad = "red", type1 = "1"})
    end
    if bones.Pizq.gravedad == 3 then 
      SendNUIMessage({type = "change", part = "Pizq", gravedad = "red", type1 = "1"})
    end
    if bones.Pder.gravedad == 3 then 
      SendNUIMessage({type = "change", part = "Pder", gravedad = "red", type1 = "1"})
    end 
    REQUEST_NUI_FOCUS(true)
    guiEnabled = true
end)

RegisterNUICallback('escape', function(data, cb)
    REQUEST_NUI_FOCUS(false)
    guiEnabled = false
    checkingOther = false
end)

function REQUEST_NUI_FOCUS(bool)
    SetNuiFocus(bool, bool) -- focus, cursor
    if bool == true then
        SendNUIMessage({type = "on", enable = true})
    else
        SendNUIMessage({type = "on", enable = false})
    end
    return bool
end

local healingOther = false

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
        if guiEnabled then
            DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
            DisableControlAction(0, 2, guiEnabled) -- LookUpDown

            DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlterna
            DisableControlAction(0, 12, guiEnabled) 
            DisableControlAction(0, 13, guiEnabled) 
            DisableControlAction(0, 14, guiEnabled) 
            DisableControlAction(0, 15, guiEnabled) 
            DisableControlAction(0, 16, guiEnabled)
            DisableControlAction(0, 17, guiEnabled)  

            DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride
            DisableControlAction(0, 48, guiEnabled)
        end
        if IsControlJustPressed(0,48) then
            guiEnabled = true
            TriggerEvent('medSys:on')
            guiEnableded = true
        end
        if IsControlJustPressed(0,137) and healingOther == false then 
          TriggerEvent('medSys:checkOther')
        end
        if guiEnabled == false and guiEnableded == true then
          guiEnableded = false
        end


        if Get3DDistance(298.73,-599.24,43.29,coords.x,coords.y,coords.z) < 3.0 then
	    	DrawText3D({x = 298.73, y = -599.24, z = 43.29 + 1}, '[~b~E~w~] Comerciar')
	    	if IsControlJustReleased(1,38) then
	    		OpenShop()
	    	end
		end
    end
end)

--======================================================================
--===============================OTHERS=================================
--======================================================================  

local checkingOther = false

RegisterNetEvent('medSys:checkOther')
AddEventHandler('medSys:checkOther', function()
  Citizen.CreateThread(function()
    local plyPed = GetPlayerPed(-1)
    local plyPos = GetEntityCoords(plyPed)
    local players = ESX.Game.GetPlayersInArea(plyPos, 1.0)

    local closest,dist 
    for k,v in pairs(players) do 
      local plyId = GetPlayerServerId(v)
      if plyId ~= GetPlayerServerId(PlayerId()) then 
        local curDist = GetVecDist(GetEntityCoords(GetPlayerPed(v)), plyPos)
        if not dist or curDist < dist then 
          closest = v 
          dist = curDist 
        end
      end
    end

    if not dist or dist > 10.0 then return; end

    ESX.TriggerServerCallback('medSys:GetOtherData', function(data)
      local otherBones = {}
      local otherBleeding
      local otherToxicity
      local otherState
      if data then 
        otherBones = data.bones
        otherBleeding = data.bleeding
        otherToxicity = data.toxicity
        otherState = data.state 
      end

      local otherH = GetEntityHealth(GetPlayerPed(closest))
      local otherA = GetPedArmour(GetPlayerPed(closest))
      local otherAllHealth = otherH + otherA
      local otherHealth = (math.max(otherH-100,0)/2) + (otherA/2)

      SendNUIMessage({type = "change", part = "Cabeza", gravedad = "white", type1 = "0"})
      SendNUIMessage({type = "change", part = "Torso", gravedad = "white", type1 = "0"})
      SendNUIMessage({type = "change", part = "Pizq", gravedad = "white", type1 = "0"})
      SendNUIMessage({type = "change", part = "Pder", gravedad = "white", type1 = "0"})
      SendNUIMessage({type = "change", part = "Bizq", gravedad = "white", type1 = "0"})
      SendNUIMessage({type = "change", part = "Bder", gravedad = "white", type1 = "0"})
      if otherBones.Cabeza.gravedad == 0 then 
        SendNUIMessage({type = "change", part = "Cabeza", gravedad = "white", type1 = "1"})
      end
      if otherBones.Torso.gravedad == 0 then 
        SendNUIMessage({type = "change", part = "Torso", gravedad = "white", type1 = "1"})
      end
      if otherBones.Bizq.gravedad == 0 then 
        SendNUIMessage({type = "change", part = "Bizq", gravedad = "white", type1 = "1"})
      end
      if otherBones.Bder.gravedad == 0 then 
        SendNUIMessage({type = "change", part = "Bder", gravedad = "white", type1 = "1"})
      end
      if otherBones.Pizq.gravedad == 0 then 
        SendNUIMessage({type = "change", part = "Pizq", gravedad = "white", type1 = "1"})
      end
      if otherBones.Pder.gravedad == 0 then 
        SendNUIMessage({type = "change", part = "Pder", gravedad = "white", type1 = "1"})
      end  

      if otherBones.Cabeza.gravedad == 1 then 
        SendNUIMessage({type = "change", part = "Cabeza", gravedad = "yellow", type1 = "1"})
      end
      if otherBones.Torso.gravedad == 1 then 
        SendNUIMessage({type = "change", part = "Torso", gravedad = "yellow", type1 = "1"})
      end
      if otherBones.Bizq.gravedad == 1 then 
        SendNUIMessage({type = "change", part = "Bizq", gravedad = "yellow", type1 = "1"})
      end
      if otherBones.Bder.gravedad == 1 then 
        SendNUIMessage({type = "change", part = "Bder", gravedad = "yellow", type1 = "1"})
      end
      if otherBones.Pizq.gravedad == 1 then 
        SendNUIMessage({type = "change", part = "Pizq", gravedad = "yellow", type1 = "1"})
      end
      if otherBones.Pder.gravedad == 1 then 
        SendNUIMessage({type = "change", part = "Pder", gravedad = "yellow", type1 = "1"})
      end  

      if otherBones.Cabeza.gravedad == 2 then 
        SendNUIMessage({type = "change", part = "Cabeza", gravedad = "orange", type1 = "1"})
      end
      if otherBones.Torso.gravedad == 2 then 
        SendNUIMessage({type = "change", part = "Torso", gravedad = "orange", type1 = "1"})
      end
      if otherBones.Bizq.gravedad == 2 then 
        SendNUIMessage({type = "change", part = "Bizq", gravedad = "orange", type1 = "1"})
      end
      if otherBones.Bder.gravedad == 2 then 
        SendNUIMessage({type = "change", part = "Bder", gravedad = "orange", type1 = "1"})
      end
      if otherBones.Pizq.gravedad == 2 then 
        SendNUIMessage({type = "change", part = "Pizq", gravedad = "orange", type1 = "1"})
      end
      if otherBones.Pder.gravedad == 2 then 
        SendNUIMessage({type = "change", part = "Pder", gravedad = "orange", type1 = "1"})
      end 

      if otherBones.Cabeza.gravedad == 3 then 
        SendNUIMessage({type = "change", part = "Cabeza", gravedad = "red", type1 = "1"})
      end
      if otherBones.Torso.gravedad == 3 then 
        SendNUIMessage({type = "change", part = "Torso", gravedad = "red", type1 = "1"})
      end
      if otherBones.Bizq.gravedad == 3 then 
        SendNUIMessage({type = "change", part = "Bizq", gravedad = "red", type1 = "1"})
      end
      if otherBones.Bder.gravedad == 3 then 
        SendNUIMessage({type = "change", part = "Bder", gravedad = "red", type1 = "1"})
      end
      if otherBones.Pizq.gravedad == 3 then 
        SendNUIMessage({type = "change", part = "Pizq", gravedad = "red", type1 = "1"})
      end
      if otherBones.Pder.gravedad == 3 then 
        SendNUIMessage({type = "change", part = "Pder", gravedad = "red", type1 = "1"})
      end 

      SendNUIMessage({type = "status", health = otherHealth, bleeding = otherBleeding})
      REQUEST_NUI_FOCUS(true)
      guiEnabled = true
      checkingOther = true
    end, GetPlayerServerId(closest))
  end)
end)

--======================================================================
--=================================CURA=================================
--======================================================================  

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(0)
    if toxicity >= 1 then
      Citizen.Wait(25000)
      toxicity = toxicity - 10
      if toxicity < 0 then
        toxicity = 0 
      end
    end
  end
end)

function SpawnPed(model, coords)
	model = (tonumber(model) ~= nil and tonumber(model) or GetHashKey(model))
	local x = coords.x
	local y = coords.y
	local z = coords.z
	local h = coords.h

	Citizen.CreateThread(function()
		RequestModel(model)

		while not HasModelLoaded(model) do
			Citizen.Wait(1)
		end

		ped = CreatePed(5, model, x, y, z, h, false, false)
		FreezeEntityPosition(ped,true)
	end)
end

function OpenShop() 
	local elements = { 
		{label = 'Venda compresiva - 5€', value = "venda_compresiva", price = 10},
		{label = 'Venda - 10€', value = "Venda", price = 10},
		{label = 'Tramadol', value = "Tramadol", price = 0},
		{label = 'Morfina', value = "Morfina", price = 0},
		{label = 'Bolsa de sangre', value = "bolsa_de_sangre", price = 0},
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'warehouse_load', {
		title    = 'Farmacia',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)
		if data.current.value then
			if job == 'ambulance' then
				TriggerServerEvent('medSys:buyItem', data.current.value, data.current.price)
			else
				if data.current.value == 'Tramadol' or data.current.value == 'Morfina' or data.current.value == 'bolsa_de_sangre' then 
					notqualified()
				else
					TriggerServerEvent('medSys:buyItem', data.current.value, data.current.price)
				end
			end
		end
	end,
	function(data, menu)
		menu.close()
	end)
end

function notqualified()
	TriggerEvent("pNotify:SetQueueMax", "center", 2)
	TriggerEvent("pNotify:SendNotification", {
    text = 'No estás lo suficiententemente cualificado para hacer eso.',
    type = "success",
    timeout = 3000,
    layout = "centerRight",
    queue = "center"
})
end

RegisterNUICallback('aplicar', function(data, cb)
	if type(data.part) == "string" and type(data.med) == "string" then
	    local mZone = data.part
	    local mMed = data.med
	    local qualified = true
	    if mZone == 'Pierna derecha' then 
	      mZone = 'Pder'
	    elseif mZone == 'Pierna izquierda' then 
	      mZone = 'Pizq'
	    elseif mZone == 'Brazo izquierdo' then 
	      mZone = 'Bizq'
	    elseif mZone == 'Brazo derecho' then 
	      mZone = 'Bder'
	    elseif mMed == 'Venda compresiva' then 
	      mMed = 'venda_compresiva'
	    elseif mMed == 'Bolsa de sangre' then 
	      mMed = 'bolsa_de_sangre'
	    end
	    if mMed == 'Venda compresiva' then 
	      mMed = 'venda_compresiva'
	    end
	    if mMed == 'Bolsa de sangre' then 
	      mMed = 'bolsa_de_sangre'
	    end

	    if job ~= 'ambulance' then 
	    	if mMed == 'Tramadol' or mMed == 'Morfina' or mMed == 'bolsa_de_sangre' then 
	    		qualified = false 
	    	end
	    end

	    if mZone ~= nil and mMed ~= nil then
		    ESX.TriggerServerCallback('medSys:removeItem', function(item)
		    	if item == true then
				    if checkingOther == true and qualified == true then 
				      local plyPed = GetPlayerPed(-1)
				      local plyPos = GetEntityCoords(plyPed)
				      local players = ESX.Game.GetPlayersInArea(plyPos, 20.0)
				      local closest,dist
				      for k,v in pairs(players) do
				        local plyId = GetPlayerServerId(v)
				        if plyId ~= GetPlayerServerId(PlayerId()) then
				          local curDist = GetVecDist(GetEntityCoords(GetPlayerPed(v)), plyPos)
				          if not dist or curDist < dist then
				            closest = v
				            dist = curDist
				          end
				        end
				      end  
				      TriggerServerEvent('medSys:healOther', GetPlayerServerId(closest), mMed, mZone)
				      REQUEST_NUI_FOCUS(false)
				      guiEnabled = false
				      checkingOther = false
				      healingOther = true
				    elseif checkingOther == false and qualified == true then 
				      TriggerEvent('medSys:heal', mMed, mZone)
				    elseif qualified == false then 
				    	notqualified()
				    end
				end
			end, mMed)
		end
	end
end)

RegisterNetEvent('medSys:heal')
AddEventHandler('medSys:heal', function(med, zone)  
  if inconsciente == false then
    if med == 'venda_compresiva' then
    	ExecuteCommand("me se pone una venda compresiva")
        exports['mythic_progbar']:Progress({
          name = "firstaid_action",
          duration = 7000,
          label = "Venda compresiva",
          useWhileDead = false,
          canCancel = true,
          controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              animDict = "missheistdockssetup1clipboard@idle_a",
              anim = "idle_a",
              flags = 49,
          },
          prop = {
              model = "prop_ld_health_pack",
          }
        }, function(status)
          if not status then
            if checkingOther == false then
              if bleeding >= 1 then
                bleeding = bleeding - 1
              end
              SendNUIMessage({type = "status", health = allHealth, bleeding = bleeding})
              Update()
            end
          end
        end)
    elseif med == 'Venda' then
    	ExecuteCommand("me se pone una venda")
        exports['mythic_progbar']:Progress({
          name = "firstaid_action",
          duration = 7000,
          label = "Venda",
          useWhileDead = false,
          canCancel = true,
          controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              animDict = "missheistdockssetup1clipboard@idle_a",
              anim = "idle_a",
              flags = 49,
          },
          prop = {
              model = "prop_stat_pack_01",
          }
        }, function(status)
          if not status then
            if checkingOther == false then
              if zone == 'Bizq' then
                if bones.Bizq.gravedad == 1 or bones.Bizq.gravedad == 2 or bones.Bizq.gravedad == 3 then
                  bones.Bizq.gravedad = bones.Bizq.gravedad - 1
                  bones.Bizq.dmg = bones.Bizq.dmg - 1
                  if bones.Bizq.gravedad == 1 then
                    SendNUIMessage({type = "change", part = "Bizq", gravedad = "yellow", type1 = "1"})
                  elseif bones.Bizq.gravedad == 2 then 
                    SendNUIMessage({type = "change", part = "Bizq", gravedad = "orange", type1 = "1"})
                  elseif bones.Bizq.gravedad == 3 then 
                    SendNUIMessage({type = "change", part = "Bizq", gravedad = "red", type1 = "1"})
                  elseif bones.Bizq.gravedad == 0 then 
                    SendNUIMessage({type = "change", part = "Bizq", gravedad = "white", type1 = "0"})
                  end
                end
              elseif zone == 'Bder' then
                if bones.Bder.gravedad == 1 or bones.Bder.gravedad == 2 or bones.Bder.gravedad == 3 then
                  bones.Bder.gravedad = bones.Bder.gravedad - 1
                  bones.Bder.dmg = bones.Bder.dmg - 1
                  if bones.Bder.gravedad == 1 then
                    SendNUIMessage({type = "change", part = "Bder", gravedad = "yellow", type1 = "1"})
                  elseif bones.Bder.gravedad == 2 then 
                    SendNUIMessage({type = "change", part = "Bder", gravedad = "orange", type1 = "1"})
                  elseif bones.Bder.gravedad == 3 then 
                    SendNUIMessage({type = "change", part = "Bder", gravedad = "red", type1 = "1"})
                  elseif bones.Bder.gravedad == 0 then 
                    SendNUIMessage({type = "change", part = "Bder", gravedad = "white", type1 = "0"})
                  end
                end
              elseif zone == 'Pizq' then
                if bones.Pizq.gravedad == 1 or bones.Pizq.gravedad == 2 or bones.Pizq.gravedad == 3 then
                  bones.Pizq.gravedad = bones.Pizq.gravedad - 1
                  bones.Pizq.dmg = bones.Pizq.dmg - 1
                  if bones.Pizq.gravedad == 1 then
                    SendNUIMessage({type = "change", part = "Pizq", gravedad = "yellow", type1 = "1"})
                    ResetPedMovementClipset(GetPlayerPed(-1), 0) 
                    SetPedMoveRateOverride(PlayerId(), 1.0)
                  elseif bones.Pizq.gravedad == 2 then 
                    SendNUIMessage({type = "change", part = "Pizq", gravedad = "orange", type1 = "1"})
                    SetPedMoveRateOverride(GetPlayerPed(-1), 0.4)
                    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
                  elseif bones.Pizq.gravedad == 3 then 
                    SendNUIMessage({type = "change", part = "Pizq", gravedad = "red", type1 = "1"})
                    SetPedMoveRateOverride(GetPlayerPed(-1), 0.1)
                    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
                  elseif bones.Pizq.gravedad == 0 then 
                    SendNUIMessage({type = "change", part = "Pizq", gravedad = "white", type1 = "0"})
                    ResetPedMovementClipset(GetPlayerPed(-1), 0) 
                    SetPedMoveRateOverride(PlayerId(), 1.0)
                  end
                end
              elseif zone == 'Pder' then
                if bones.Pder.gravedad == 1 or bones.Pder.gravedad == 2 or bones.Pder.gravedad == 3 then
                  bones.Pder.gravedad = bones.Pder.gravedad - 1
                  bones.Pder.dmg = bones.Pder.dmg - 1
                  if bones.Pder.gravedad == 1 then
                    SendNUIMessage({type = "change", part = "Pder", gravedad = "yellow", type1 = "1"})
                    ResetPedMovementClipset(GetPlayerPed(-1), 0) 
                    SetPedMoveRateOverride(PlayerId(), 1.0)
                  elseif bones.Pder.gravedad == 2 then 
                    SendNUIMessage({type = "change", part = "Pder", gravedad = "orange", type1 = "1"})
                    SetPedMoveRateOverride(GetPlayerPed(-1), 0.4)
                    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
                  elseif bones.Pder.gravedad == 3 then 
                    SendNUIMessage({type = "change", part = "Pder", gravedad = "red", type1 = "1"})
                    SetPedMoveRateOverride(GetPlayerPed(-1), 0.1)
                    SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
                  elseif bones.Pder.gravedad == 0 then 
                    SendNUIMessage({type = "change", part = "Pder", gravedad = "white", type1 = "0"})
                    ResetPedMovementClipset(GetPlayerPed(-1), 0) 
                    SetPedMoveRateOverride(PlayerId(), 1.0)
                  end  
                end
              end
              Update()
            end
          end
        end)
    elseif med == 'Tramadol' then 
    	ExecuteCommand("me se aplica un Tramadol")
        exports['mythic_progbar']:Progress({
          name = "firstaid_action",
          duration = 7000,
          label = "Tramadol",
          useWhileDead = false,
          canCancel = false,
          controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              animDict = "missheistdockssetup1clipboard@idle_a",
              anim = "idle_a",
              flags = 49,
          },
          prop = {
              model = "prop_stat_pack_01",
          }
        }, function(status)
          if not status then
            if checkingOther == false then
              if zone == 'Torso' then
                if bones.Torso.gravedad == 1 or bones.Torso.gravedad == 2 or bones.Torso.gravedad == 3 then
                  bones.Torso.gravedad = bones.Torso.gravedad - 1
                  bones.Torso.dmg = bones.Torso.dmg - 1
                  if bones.Torso.gravedad == 1 then
                    SendNUIMessage({type = "change", part = "Torso", gravedad = "yellow", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(1 / 10, 0.6))
                  elseif bones.Torso.gravedad == 2 then 
                    SendNUIMessage({type = "change", part = "Torso", gravedad = "orange", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(2 / 10, 0.6))
                  elseif bones.Torso.gravedad == 3 then 
                    SendNUIMessage({type = "change", part = "Torso", gravedad = "red", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(4 / 10, 0.6))
                  elseif bones.Torso.gravedad == 0 then 
                    SendNUIMessage({type = "change", part = "Torso", gravedad = "white", type1 = "0"})
                    StopScreenEffect('DeathFailOut',  0,  false)
                    ClearTimecycleModifier()
                  end                 
                end
                toxicity = toxicity + 25
              elseif zone == 'Cabeza' then
                if bones.Cabeza.gravedad == 1 or bones.Cabeza.gravedad == 2 or bones.Cabeza.gravedad == 3 then
                  bones.Cabeza.gravedad = bones.Cabeza.gravedad - 1
                  bones.Cabeza.dmg = bones.Cabeza.dmg - 1
                  if bones.Cabeza.gravedad == 1 then
                    SendNUIMessage({type = "change", part = "Cabeza", gravedad = "yellow", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(3 / 10, 0.6))
                  elseif bones.Cabeza.gravedad == 2 then 
                    SendNUIMessage({type = "change", part = "Cabeza", gravedad = "orange", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(5 / 10, 0.6))
                  elseif bones.Cabeza.gravedad == 3 then 
                    SendNUIMessage({type = "change", part = "Cabeza", gravedad = "red", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(7 / 10, 0.6))
                  elseif bones.Cabeza.gravedad == 0 then 
                    SendNUIMessage({type = "change", part = "Cabeza", gravedad = "white", type1 = "0"})
                    StopScreenEffect('DeathFailOut',  0,  false)
                    ClearTimecycleModifier()
                  end
                end
                toxicity = toxicity + 25
              end
              Update()
            end
          end
        end)
    elseif med == 'Morfina' then 
    	ExecuteCommand("se aplica una Morfina")
        exports['mythic_progbar']:Progress({
          name = "firstaid_action",
          duration = 7000,
          label = "Morfina",
          useWhileDead = false,
          canCancel = false,
          controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              animDict = "missheistdockssetup1clipboard@idle_a",
              anim = "idle_a",
              flags = 49,
          },
          prop = {
              model = "prop_stat_pack_01",
          }
        }, function(status)
          if not status then
            if checkingOther == false then
              if zone == 'Torso' then
                if bones.Torso.gravedad == 1 or bones.Torso.gravedad == 2 or bones.Torso.gravedad == 3 then
                  bones.Torso.gravedad = bones.Torso.gravedad - 2
                  bones.Torso.dmg = bones.Torso.dmg - 2
                  if bones.Torso.gravedad == -1 then 
                    bones.Torso.gravedad = 0 
                  end
                  if bones.Torso.gravedad == 1 then
                    SendNUIMessage({type = "change", part = "Torso", gravedad = "yellow", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(1 / 10, 0.6))
                  elseif bones.Torso.gravedad == 2 then 
                    SendNUIMessage({type = "change", part = "Torso", gravedad = "orange", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(2 / 10, 0.6))
                  elseif bones.Torso.gravedad == 3 then 
                    SendNUIMessage({type = "change", part = "Torso", gravedad = "red", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(4 / 10, 0.6))
                  elseif bones.Torso.gravedad == 0 then 
                    SendNUIMessage({type = "change", part = "Torso", gravedad = "white", type1 = "0"})
                    StopScreenEffect('DeathFailOut',  0,  false)
                    ClearTimecycleModifier()
                  end
                end
                toxicity = toxicity + 45
              elseif zone == 'Cabeza' then
                if bones.Cabeza.gravedad == 1 or bones.Cabeza.gravedad == 2 or bones.Cabeza.gravedad == 3 then
                  bones.Cabeza.gravedad = bones.Cabeza.gravedad - 2
                  bones.Cabeza.dmg = bones.Cabeza.dmg - 2
                  if bones.Cabeza.gravedad == -1 then 
                    bones.Cabeza.gravedad = 0 
                  end
                  if bones.Cabeza.gravedad == 1 then
                    SendNUIMessage({type = "change", part = "Cabeza", gravedad = "yellow", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(3 / 10, 0.6))
                  elseif bones.Cabeza.gravedad == 2 then 
                    SendNUIMessage({type = "change", part = "Cabeza", gravedad = "orange", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(5 / 10, 0.6))
                  elseif bones.Cabeza.gravedad == 3 then 
                    SendNUIMessage({type = "change", part = "Cabeza", gravedad = "red", type1 = "1"})
                    SetTimecycleModifier('BarryFadeOut')
                    SetTimecycleModifierStrength(math.min(7 / 10, 0.6))
                  elseif bones.Cabeza.gravedad == 0 then 
                    SendNUIMessage({type = "change", part = "Cabeza", gravedad = "white", type1 = "0"})
                    StopScreenEffect('DeathFailOut',  0,  false)
                    ClearTimecycleModifier()
                  end
                  toxicity = toxicity + 45
                end
              end
              Update()
            end
          end
        end)
    elseif med == 'bolsa_de_sangre' then 
    	ExecuteCommand("me se aplica una bolsa de sangre")
        exports['mythic_progbar']:Progress({
          name = "firstaid_action",
          duration = 7000,
          label = "Bolsa de sangre",
          useWhileDead = false,
          canCancel = true,
          controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              animDict = "missheistdockssetup1clipboard@idle_a",
              anim = "idle_a",
              flags = 49,
          },
          prop = {
              model = "prop_stat_pack_01",
          }
        }, function(status)
          if not status then
            if checkingOther == false then
              if zone == 'Bizq' then
                local mHealth = GetEntityHealth(GetPlayerPed(-1))      
                local mArmour = GetPedArmour(GetPlayerPed(-1))            
                  local mRandom = math.random(20,30)
                  local mTotal
                  if armour == 0 and health < 200 then 
                  	mTotal = mHealth + mRandom
                  	SetEntityHealth(GetPlayerPed(-1), mTotal)
                  elseif health == 200 and armour < 100 then
                  	mTotal = mArmour + mRandom
                  	SetPedArmour(GetPlayerPed(-1), mTotal)
                  end
                  
                  toxicity = toxicity + 10
              elseif zone == 'Bder' then
                local mHealth = GetEntityHealth(GetPlayerPed(-1))
                local mArmour = GetPedArmour(GetPlayerPed(-1))
                  local mRandom = math.random(20,30)
                  local mTotal
                  if armour == 0 and health < 200 then 
                  	mTotal = mHealth + mRandom
                  	SetEntityHealth(GetPlayerPed(-1), mTotal)
                  elseif health == 200 and armour < 100 then
                  	mTotal = mArmour + mRandom 
                  	SetPedArmour(GetPlayerPed(-1), mTotal)
                  end
                  toxicity = toxicity + 10
              end
              health = GetEntityHealth(GetPlayerPed(-1))
              armour = GetPedArmour(GetPlayerPed(-1))
              allHealth = (math.max(health-100,0)/2) + (armour/2)
              SendNUIMessage({type = "status", health = allHealth, bleeding = bleeding})
              Update()
            end
          end
        end)
    end
  end
end)

RegisterNetEvent('medSys:ChealOtherMedic')
AddEventHandler('medSys:ChealOtherMedic', function(med)
  if med == 'venda_compresiva' then
  ExecuteCommand("me le pone una venda compresiva") 
    exports['mythic_progbar']:Progress({
          name = "firstaid_action",
          duration = 7000,
          label = "Venda compresiva",
          useWhileDead = false,
          canCancel = true,
          controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              animDict = "missheistdockssetup1clipboard@idle_a",
              anim = "idle_a",
              flags = 49,
          },
          prop = {
              model = "prop_ld_health_pack",
          }
        }, function(status)
        healingOther = false
      end)
  elseif med == 'Venda' then 
  	ExecuteCommand("me le pone una venda")
    exports['mythic_progbar']:Progress({
          name = "firstaid_action",
          duration = 7000,
          label = "Venda",
          useWhileDead = false,
          canCancel = true,
          controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              animDict = "missheistdockssetup1clipboard@idle_a",
              anim = "idle_a",
              flags = 49,
          },
          prop = {
              model = "prop_stat_pack_01",
          }
        }, function(status)
        healingOther = false
      end)
  elseif med == 'Tramadol' then 
  	ExecuteCommand("me le aplica un Tramadol")
    exports['mythic_progbar']:Progress({
          name = "firstaid_action",
          duration = 7000,
          label = "Tramadol",
          useWhileDead = false,
          canCancel = false,
          controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              animDict = "missheistdockssetup1clipboard@idle_a",
              anim = "idle_a",
              flags = 49,
          },
          prop = {
              model = "prop_stat_pack_01",
          }
        }, function(status)
        healingOther = false
      end)
  elseif med == 'Morfina' then 
  	ExecuteCommand("me le aplica una Morfina")
    exports['mythic_progbar']:Progress({
          name = "firstaid_action",
          duration = 7000,
          label = "Morfina",
          useWhileDead = false,
          canCancel = false,
          controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              animDict = "missheistdockssetup1clipboard@idle_a",
              anim = "idle_a",
              flags = 49,
          },
          prop = {
              model = "prop_stat_pack_01",
          }
        }, function(status)
        healingOther = false
      end)
  elseif med == 'bolsa_de_sangre' then 
  	ExecuteCommand("me le aplica una bolsa de sangre")
    exports['mythic_progbar']:Progress({
          name = "firstaid_action",
          duration = 7000,
          label = "Bolsa de sangre",
          useWhileDead = false,
          canCancel = false,
          controlDisables = {
              disableMovement = true,
              disableCarMovement = true,
              disableMouse = false,
              disableCombat = true,
          },
          animation = {
              animDict = "missheistdockssetup1clipboard@idle_a",
              anim = "idle_a",
              flags = 49,
          },
          prop = {
              model = "prop_stat_pack_01",
          }
        }, function(status)
        healingOther = false
      end)
  end
end)

RegisterNetEvent('medSys:ChealOther')
AddEventHandler('medSys:ChealOther', function(med, zone)
  if med == 'venda_compresiva' then 
    Wait(7000)
    if bleeding >= 1 then 
      bleeding = bleeding - 1 
    end
    if bleeding == 0.5 then 
    	bleeding = 0
    end
    SendNUIMessage({type = "status", health = otherHealth, bleeding = otherBleeding})
    Update()
  elseif med == 'Venda' then 
    Wait(7000)
    if zone == 'Bizq' then
      if bones.Bizq.gravedad == 1 or bones.Bizq.gravedad == 2 or bones.Bizq.gravedad == 3 then
        bones.Bizq.gravedad = bones.Bizq.gravedad - 1
        bones.Bizq.dmg = bones.Bizq.dmg - 1
        if bones.Bizq.gravedad == 1 then
          SendNUIMessage({type = "change", part = "Bizq", gravedad = "yellow", type1 = "1"})
        elseif bones.Bizq.gravedad == 2 then 
          SendNUIMessage({type = "change", part = "Bizq", gravedad = "orange", type1 = "1"})
        elseif bones.Bizq.gravedad == 3 then 
          SendNUIMessage({type = "change", part = "Bizq", gravedad = "red", type1 = "1"})
        elseif bones.Bizq.gravedad == 0 then 
          SendNUIMessage({type = "change", part = "Bizq", gravedad = "white", type1 = "0"})
        end
      end
    elseif zone == 'Bder' then
      if bones.Bder.gravedad == 1 or bones.Bder.gravedad == 2 or bones.Bder.gravedad == 3 then
        bones.Bder.gravedad = bones.Bder.gravedad - 1
        bones.Bder.dmg = bones.Bder.dmg - 1
        if bones.Bder.gravedad == 1 then
          SendNUIMessage({type = "change", part = "Bder", gravedad = "yellow", type1 = "1"})
        elseif bones.Bder.gravedad == 2 then 
          SendNUIMessage({type = "change", part = "Bder", gravedad = "orange", type1 = "1"})
        elseif bones.Bder.gravedad == 3 then 
          SendNUIMessage({type = "change", part = "Bder", gravedad = "red", type1 = "1"})
        elseif bones.Bder.gravedad == 0 then 
          SendNUIMessage({type = "change", part = "Bder", gravedad = "white", type1 = "0"})
        end
      end
    elseif zone == 'Pizq' then
      if bones.Pizq.gravedad == 1 or bones.Pizq.gravedad == 2 or bones.Pizq.gravedad == 3 then
        bones.Pizq.gravedad = bones.Pizq.gravedad - 1
        bones.Pizq.dmg = bones.Pizq.dmg - 1
        if bones.Pizq.gravedad == 1 then
          SendNUIMessage({type = "change", part = "Pizq", gravedad = "yellow", type1 = "1"})
          ResetPedMovementClipset(GetPlayerPed(-1), 0) 
          SetPedMoveRateOverride(PlayerId(), 1.0)
        elseif bones.Pizq.gravedad == 2 then 
          SendNUIMessage({type = "change", part = "Pizq", gravedad = "orange", type1 = "1"})
          SetPedMoveRateOverride(GetPlayerPed(-1), 0.4)
          SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
        elseif bones.Pizq.gravedad == 3 then 
          SendNUIMessage({type = "change", part = "Pizq", gravedad = "red", type1 = "1"})
          SetPedMoveRateOverride(GetPlayerPed(-1), 0.1)
          SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
        elseif bones.Pizq.gravedad == 0 then 
          SendNUIMessage({type = "change", part = "Pizq", gravedad = "white", type1 = "0"})
          ResetPedMovementClipset(GetPlayerPed(-1), 0) 
          SetPedMoveRateOverride(PlayerId(), 1.0)
        end
      end
    elseif zone == 'Pder' then
      if bones.Pder.gravedad == 1 or bones.Pder.gravedad == 2 or bones.Pder.gravedad == 3 then
        bones.Pder.gravedad = bones.Pder.gravedad - 1
        bones.Pder.dmg = bones.Pder.dmg - 1
        if bones.Pder.gravedad == 1 then
          SendNUIMessage({type = "change", part = "Pder", gravedad = "yellow", type1 = "1"})
          ResetPedMovementClipset(GetPlayerPed(-1), 0) 
          SetPedMoveRateOverride(PlayerId(), 1.0)
        elseif bones.Pder.gravedad == 2 then 
          SendNUIMessage({type = "change", part = "Pder", gravedad = "orange", type1 = "1"})
          SetPedMoveRateOverride(GetPlayerPed(-1), 0.4)
          SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
        elseif bones.Pder.gravedad == 3 then 
          SendNUIMessage({type = "change", part = "Pder", gravedad = "red", type1 = "1"})
          SetPedMoveRateOverride(GetPlayerPed(-1), 0.1)
          SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
        elseif bones.Pder.gravedad == 0 then 
          SendNUIMessage({type = "change", part = "Pder", gravedad = "white", type1 = "0"})
          ResetPedMovementClipset(GetPlayerPed(-1), 0) 
          SetPedMoveRateOverride(PlayerId(), 1.0)
        end  
      end
    end
    Update()
  elseif med == 'Tramadol' then 
    Wait(7000)
    if zone == 'Torso' then
      if bones.Torso.gravedad == 1 or bones.Torso.gravedad == 2 or bones.Torso.gravedad == 3 then
        bones.Torso.gravedad = bones.Torso.gravedad - 1
        bones.Torso.dmg = bones.Torso.dmg - 1
        if bones.Torso.gravedad == 1 then
          SendNUIMessage({type = "change", part = "Torso", gravedad = "yellow", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(1 / 10, 0.6))
        elseif bones.Torso.gravedad == 2 then 
          SendNUIMessage({type = "change", part = "Torso", gravedad = "orange", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(2 / 10, 0.6))
        elseif bones.Torso.gravedad == 3 then 
          SendNUIMessage({type = "change", part = "Torso", gravedad = "red", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(4 / 10, 0.6))
        elseif bones.Torso.gravedad == 0 then 
          SendNUIMessage({type = "change", part = "Torso", gravedad = "white", type1 = "0"})
          StopScreenEffect('DeathFailOut',  0,  false)
          ClearTimecycleModifier()
        end
      end
      toxicity = toxicity + 25
    elseif zone == 'Cabeza' then
      if bones.Cabeza.gravedad == 1 or bones.Cabeza.gravedad == 2 or bones.Cabeza.gravedad == 3 then
        bones.Cabeza.gravedad = bones.Cabeza.gravedad - 1
        bones.Cabeza.dmg = bones.Cabeza.dmg - 1
        if bones.Cabeza.gravedad == 1 then
          SendNUIMessage({type = "change", part = "Cabeza", gravedad = "yellow", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(3 / 10, 0.6))
        elseif bones.Cabeza.gravedad == 2 then 
          SendNUIMessage({type = "change", part = "Cabeza", gravedad = "orange", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(5 / 10, 0.6))
        elseif bones.Cabeza.gravedad == 3 then 
          SendNUIMessage({type = "change", part = "Cabeza", gravedad = "red", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(7 / 10, 0.6))
        elseif bones.Cabeza.gravedad == 0 then 
          SendNUIMessage({type = "change", part = "Cabeza", gravedad = "white", type1 = "0"})
          StopScreenEffect('DeathFailOut',  0,  false)
          ClearTimecycleModifier()
        end                 
      end
      toxicity = toxicity + 25
    end
    Update()
  elseif med == 'Morfina' then 
    Wait(7000)
    if zone == 'Torso' then
      if bones.Torso.gravedad == 1 or bones.Torso.gravedad == 2 or bones.Torso.gravedad == 3 then
        bones.Torso.gravedad = bones.Torso.gravedad - 2
        bones.Torso.dmg = bones.Torso.dmg - 2
        if bones.Torso.gravedad == -1 then 
          bones.Torso.gravedad = 0 
        end
        if bones.Torso.gravedad == 1 then
          SendNUIMessage({type = "change", part = "Torso", gravedad = "yellow", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(1 / 10, 0.6))
        elseif bones.Torso.gravedad == 2 then 
          SendNUIMessage({type = "change", part = "Torso", gravedad = "orange", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(2 / 10, 0.6))
        elseif bones.Torso.gravedad == 3 then 
          SendNUIMessage({type = "change", part = "Torso", gravedad = "red", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(4 / 10, 0.6))
        elseif bones.Torso.gravedad == 0 then 
          SendNUIMessage({type = "change", part = "Torso", gravedad = "white", type1 = "0"})
          StopScreenEffect('DeathFailOut',  0,  false)
          ClearTimecycleModifier()
        end
      end
      toxicity = toxicity + 45
    elseif zone == 'Cabeza' then
      if bones.Cabeza.gravedad == 1 or bones.Cabeza.gravedad == 2 or bones.Cabeza.gravedad == 3 then
        bones.Cabeza.gravedad = bones.Cabeza.gravedad - 2
        bones.Cabeza.dmg = bones.Cabeza.dmg - 2
        if bones.Cabeza.gravedad == -1 then 
          bones.Cabeza.gravedad = 0 
        end
        if bones.Cabeza.gravedad == 1 then
          SendNUIMessage({type = "change", part = "Cabeza", gravedad = "yellow", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(3 / 10, 0.6))
        elseif bones.Cabeza.gravedad == 2 then 
          SendNUIMessage({type = "change", part = "Cabeza", gravedad = "orange", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(5 / 10, 0.6))
        elseif bones.Cabeza.gravedad == 3 then 
          SendNUIMessage({type = "change", part = "Cabeza", gravedad = "red", type1 = "1"})
          SetTimecycleModifier('BarryFadeOut')
          SetTimecycleModifierStrength(math.min(7 / 10, 0.6))
        elseif bones.Cabeza.gravedad == 0 then 
          SendNUIMessage({type = "change", part = "Cabeza", gravedad = "white", type1 = "0"})
          StopScreenEffect('DeathFailOut',  0,  false)
          ClearTimecycleModifier()
          end
        end
        toxicity = toxicity + 45
      end
      Update()
  elseif med == 'bolsa_de_sangre' then
    Wait(7000)
    if zone == 'Bizq' then    
      local mHealth = GetEntityHealth(GetPlayerPed(-1))    
      local mArmour = GetPedArmour(GetPlayerPed(-1)) 
      local mRandom = math.random(20,30)
      local mTotal
      if armour == 0 and health < 200 then 
      	mTotal = mHealth + mRandom
      	SetEntityHealth(GetPlayerPed(-1), mTotal)
      elseif health == 200 and armour < 100 then
      	mTotal = mArmour + mRandom
      	SetPedArmour(GetPlayerPed(-1), mArmour)
      end
      toxicity = toxicity + 10
    elseif zone == 'Bder' then
      local mHealth = GetEntityHealth(GetPlayerPed(-1))
      local mArmour = GetPedArmour(GetPlayerPed(-1)) 
      local mRandom = math.random(20,30)
      local mTotal
      if armour == 0 and health < 200 then  
      	mTotal = mHealth + mRandom
      	SetEntityHealth(GetPlayerPed(-1), mTotal)
      elseif health == 200 and armour < 100 then
      	mTotal = mArmour + mRandom
      	SetPedArmour(GetPlayerPed(-1), mArmour)
      end
      toxicity = toxicity + 10
    end
    SendNUIMessage({type = "status", health = otherHealth, bleeding = otherBleeding})
    Update()
  end
end)

--======================================================================
--=================================SPAWN================================
--======================================================================

AddEventHandler('playerSpawned', function(spawn) 
	clear()
end)

--======================================================================
--==========================INCONSCIENCIA===============================
--======================================================================

function doInconsciente()
    if not(dead) and health >= 1 then 
      inconsciente = true
      state = "INCONSCIENTE"
      tick = 65
      StartScreenEffect('DeathFailOut',  0,  false)
    end
    while inconsciente do
            Citizen.Wait(0)
            SetTextFont(7)
            SetTextProportional(0)
            SetTextScale(0.0, 1.5)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)

            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")

            local text = "Estás inconsciente"

            AddTextComponentString(text)
            SetTextCentre(true)
            DrawText(0.5, 0.4)
            SetPedToRagdoll(GetPlayerPed(-1),1000, 1000, 0,0,0,0)
            timer = true
            if tick <= 0 then 
            	inconsciente = false
            	timer = false
            	StopScreenEffect('DeathFailOut',  0,  false)
            end
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if timer then 
			tick = tick - 1
		end
	end
end)

--======================================================================
--=================================MUERTE===============================
--======================================================================

AddEventHandler('esx:onPlayerDeath', function(data)
  --OnPlayerDeath()
  dead = true
  inconsciente = false
end)

--======================================================================
--====================================DAÑO==============================
--======================================================================

Citizen.CreateThread(function() 
  while true do 
    Citizen.Wait(10000)
    if not(dead) and bleeding >= 1 then
      if armour > 0 and health == 200 then 
      	totalHealth = armour - bleeding
      	SetPedArmour(GetPlayerPed(-1), totalHealth)
      else
      	totalHealth = health - bleeding
      	SetEntityHealth(GetPlayerPed(-1), totalHealth)
      end
      a = true
      local hit, bone = GetPedLastDamageBone(GetPlayerPed(-1))
      Wait(1000)
      a = false
      health = GetEntityHealth(GetPlayerPed(-1))
      armour = GetPedArmour(GetPlayerPed(-1))
      SendNUIMessage({type = "status", health = allHealth, bleeding = bleeding})
    end
  end
end)


Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    health = GetEntityHealth(GetPlayerPed(-1)) 
    armour = GetPedArmour(GetPlayerPed(-1))
    allHealth = (math.max(health-100,0)/2) + (armour/2)
    SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
    coords = GetEntityCoords(PlayerPedId())
    if toxicity >= 100 then
      SetEntityHealth(GetPlayerPed(-1), 0)
    end

    if inconsciente == true then
      state = "INCONSCIENTE"
    elseif dead then 
      state = "MUERTO"
    elseif dead == false and inconsciente == false and bleeding == 0 then
      state = "VIVO"
    else
      state = "VIVO"
    end

    if bones.Cabeza.dmg == 3 or bones.Torso.dmg == 3 then 
    	doInconsciente()
    end

    if bones.Pizq.dmg == 4 or bones.Pder.dmg == 4 or bones.Bizq.dmg == 4 or bones.Bder.dmg == 4 then 
    	doInconsciente()
    end

    if bleeding >= 10 then 
    	doInconsciente()
    end

    local prevHealth = GetEntityHealth(GetPlayerPed(-1))
    local prevArmour = GetPedArmour(GetPlayerPed(-1))
    if prevHealth and prevArmour then 
      Wait(1000)
      local currentHealth = GetEntityHealth(GetPlayerPed(-1))
      local currentArmour = GetPedArmour(GetPlayerPed(-1))
      if currentHealth < prevHealth or currentArmour < prevArmour and a == false and b == false then
          x = prevHealth - currentHealth
          z = prevArmour - currentArmour
          print(z)
          health = GetEntityHealth(GetPlayerPed(-1))
          armour = GetPedArmour(GetPlayerPed(-1))
          local hit, bone = GetPedLastDamageBone(GetPlayerPed(-1))
          if bone and a == false then 
            for i,v in pairs(PedBones["Brazo derecho"]) do
              if v == bone then 
                bones.Bder.dmg = bones.Bder.dmg + 1
                if x > 0 or z > 0 then 
                  if x <= 24 or z <= 24 then
                    bones.Bder.gravedad = 1
                    bleeding = bleeding + 1

                    brazos(1)
                    Update()
                  end
                  if x <= 50 and x >= 25 or z <= 50 and z >= 25 then
                    bones.Bder.gravedad = 2
                    bleeding = bleeding + 2

                    brazos(3)
                    Update()
                  end
                  if x > 50 or z > 50 then
                    bones.Bder.gravedad = 3
                    bleeding = bleeding + 3

                    brazos(5)
                    Update()
                  end
                end
              end
            end
            for i,v in pairs(PedBones["Brazo izquierdo"]) do
              if v == bone then  
                bones.Bizq.dmg = bones.Bizq.dmg + 1
                if x > 0 or z > 0 then 
                  if x <= 24 or z <= 24 then
                    bones.Bizq.gravedad = 1
                    bleeding = bleeding + 1

                    brazos(1)
                    Update()
                  end
                  if x <= 50 and x >= 25 or z <= 50 and z >= 25 then 
                    bones.Bizq.gravedad = 2
                    bleeding = bleeding + 2

                    brazos(3)
                    Update()
                  end
                  if x > 50 or z > 50 then
                    bones.Bizq.gravedad = 3
                    bleeding = bleeding + 3

                    brazos(5)
                    Update()
                  end
                end
              end
            end
            for i,v in pairs(PedBones["Pierna derecha"]) do
              if v == bone then  
                bones.Pder.dmg = bones.Pder.dmg + 1
                if x > 0 or z > 0 then
                  if x <= 24 or z <= 24 then
                    bones.Pder.gravedad = 1
                    bleeding = bleeding + 1
                    Update()
                  end
                  if x <= 50 and x >= 25 or z <= 50 and z >= 25 then 
                    bones.Pder.gravedad = 2
                    bleeding = bleeding + 2

                    SetPedMoveRateOverride(GetPlayerPed(-1), 0.4)
            				SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
            				Update()
                  end
                  if x > 50 or z > 50 then
                    bones.Pder.gravedad = 3
                    bleeding = bleeding + 3

                    SetPedMoveRateOverride(GetPlayerPed(-1), 0.1)
      				      SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
      				      Update()
                  end
                end
              end
            end
            for i,v in pairs(PedBones["Pierna izquierda"]) do
              if v == bone then 
                bones.Pizq.dmg = bones.Pizq.dmg + 1
                if x > 0 or z > 0 then
                  if x <= 24 or z <= 24 then
                    bones.Pizq.gravedad = 1
                    bleeding = bleeding + 1
                    Update()
                  end
                  if x <= 50 and x >= 25 or z <= 50 and z >= 25 then 
                    bones.Pizq.gravedad = 2
                    bleeding = bleeding + 2

                    SetPedMoveRateOverride(GetPlayerPed(-1), 0.4)
            				SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
            				Update()
                  end
                  if x > 50 or z > 50 then
                    bones.Pizq.gravedad = 3
                    bleeding = bleeding + 3
 

                    SetPedMoveRateOverride(GetPlayerPed(-1), 0.1)
            				SetPedMovementClipset(GetPlayerPed(-1), "move_m@injured", true)
            				Update()
                  end
                end
              end
            end
            for i,v in pairs(PedBones["Cabeza"]) do
              if v == bone then
                bones.Cabeza.dmg = bones.Cabeza.dmg + 1
                if x > 0 or z > 0 then 
                  if x <= 24 or z <= 14then
                    bones.Cabeza.gravedad = 1
                    bleeding = bleeding + 3
 

                    SetTimecycleModifier('BarryFadeOut')
            				SetTimecycleModifierStrength(math.min(3 / 10, 0.6))
            				Update()
                  end
                  if x <= 50 and x >= 25 or z <= 50 and z >= 25 then 
                    bones.Cabeza.gravedad = 2
                    bleeding = bleeding + 4
 
                    Update()
                    doInconsciente()

                    SetTimecycleModifier('BarryFadeOut')
      				      SetTimecycleModifierStrength(math.min(5 / 10, 0.6))
                  end
                  if x > 50 or z > 50 then
                    bones.Cabeza.gravedad = 3
                    bleeding = bleeding + 5
 
                    Update()
                    doInconsciente()

                    SetTimecycleModifier('BarryFadeOut')
      				      SetTimecycleModifierStrength(math.min(7 / 10, 0.6))
                  end
                end
              end
            end
            for i,v in pairs(PedBones["Torso"]) do
              if v == bone then
                bones.Torso.dmg = bones.Torso.dmg + 1
                if x > 0 or z > 0 then
	                if x <= 24 or z <= 24 then
	                  bones.Torso.gravedad = 1
	                  bleeding = bleeding + 2

	                  SetTimecycleModifier('BarryFadeOut')
	      			      SetTimecycleModifierStrength(math.min(1 / 10, 0.6))
	      			      Update()
	                end
	                if x <= 50 and x >= 25 or z <= 50 and z >= 25 then
	                  bones.Torso.gravedad = 1
	                  bleeding = bleeding + 3
	                  random = math.random(1,3)
	                  if random == 2 then
	                  	Update() 
	                  end
	                  SetTimecycleModifier('BarryFadeOut')
	      			      SetTimecycleModifierStrength(math.min(2 / 10, 0.6))
	      			      Update()
	                end
	                if x > 50 or z > 50 then
	                  bones.Torso.gravedad = 1
	                  bleeding = bleeding + 5
	                  Update()
	                  doInconsciente()
	                  SetTimecycleModifier('BarryFadeOut')
	      			      SetTimecycleModifierStrength(math.min(4 / 10, 0.6))
	                end
	            end
              end
            end
          end
      	end
  	end
  end
end)

function brazos(multiplier)
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			if IsPedShooting(GetPlayerPed(-1)) then 
        		ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', multiplier / 10.0)
        	end
       	end
	end)
end

--======================================================================
--===================================BD=================================
--======================================================================

Citizen.CreateThread(function()
  SpawnPed(-730659924, {x = 298.73, y = -599.24, z = 43.29 - 1, h = 341.11})
  ESX.TriggerServerCallback('medSys:GetData', function(data)
    if data then 
      bones = data.bones
	  end
  end)
end)


function Update()
  local data = {bones = bones, bleeding = bleeding, toxicity = toxicity, state = state}
  TriggerServerEvent('medSys:saveData', data)
end

--======================================================================
--==========================FUNCIONES DE TERCEROS=======================
--======================================================================

function stringsplit(inputstr, sep)
  if sep == nil then
      sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
      t[i] = str
      i = i + 1
  end
  return t
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x , y)
end

function Get3DDistance(x1, y1, z1, x2, y2, z2)
	local a = (x1 - x2) * (x1 - x2)
	local b = (y1 - y2) * (y1 - y2)
	local c = (z1 - z2) * (z1 - z2)
    return math.sqrt(a + b + c)
end

function DrawText3D(coords, text, size)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(0)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry('STRING')
		SetTextCentre(1)

		AddTextComponentString(text)
		DrawText(x, y)
	end
end

function GetVecDist(v1,v2)
  if not v1 or not v2 or not v1.x or not v2.x then return 0; end
  return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
end

--======================================================================
--===================================BONES==============================
--======================================================================

PedBones = {
  ["Torso"] = {
    SKEL_ROOT = 0x0,
    SKEL_Pelvis = 0x2E28, 
    SKEL_Spine_Root = 0xE0FD,
    SKEL_Spine0 = 0x5C01,
    SKEL_Spine1 = 0x60F0,
    SKEL_Spine2 = 0x60F1,
    SKEL_Spine3 = 0x60F2,
    SPR_L_Breast = 0xFC8E,
    SPR_R_Breast = 0x885F,
    IK_Root = 0xDD1C,
    SKEL_Pelvis1 = 0xD003,
    SKEL_PelvisRoot = 0x45FC,
    SKEL_SADDLE = 0x9524,
    SM_M_BackSkirtRoll = 0xDBB,
    SM_M_FrontSkirtRoll = 0xCDBB,
    SM_CockNBalls_ROOT = 0xC67D,
    SM_CockNBalls = 0x9D34, 
    BagRoot = 0xAD09,
    BagPivotROOT = 0xB836,
    BagPivot = 0x4D11,
    BagBody = 0xAB6D,
    BagBone_R = 0x937,
    BagBone_L = 0x991,
    SM_LifeSaver_Front = 0x9420,
    SM_R_Pouches_ROOT = 0x2962,
    SM_R_Pouches = 0x4141,
    SM_L_Pouches_ROOT = 0x2A02,
    SM_L_Pouches = 0x4B41,
    SM_Suit_Back_Flapper = 0xDA2D,
    SPR_CopRadio = 0x8245,
    SM_LifeSaver_Back = 0x2127,
    MH_BlushSlider = 0xA0CE,
    SKEL_Tail_01 = 0x347,
    SKEL_Tail_02 = 0x348,
    MH_L_Concertina_B = 0xC988,
    MH_L_Concertina_A = 0xC987,
    MH_R_Concertina_B = 0xC8E8,
    MH_R_Concertina_A = 0xC8E7,
    SKEL_Tail_03 = 0x349,
    SKEL_Tail_04 = 0x34A,
    SKEL_Tail_05 = 0x34B,
    SPR_Gonads_ROOT = 0xBFDE,
    SPR_Gonads = 0x1C00,
  },

  ["Cabeza"] = {
    SKEL_Neck_1 = 0x9995,
    SKEL_Head = 0x796E,
    IK_Head = 0x322C,
    FACIAL_facialRoot = 0xFE2C,
    FB_L_Brow_Out_000 = 0xE3DB,
    FB_L_Lid_Upper_000 = 0xB2B6,
    FB_L_Eye_000 = 0x62AC,
    FB_L_CheekBone_000 = 0x542E,
    FB_L_Lip_Corner_000 = 0x74AC,
    FB_R_Lid_Upper_000 = 0xAA10,
    FB_R_Eye_000 = 0x6B52,
    FB_R_CheekBone_000 = 0x4B88,
    FB_R_Brow_Out_000 = 0x54C,
    FB_R_Lip_Corner_000 = 0x2BA6,
    FB_Brow_Centre_000 = 0x9149,
    FB_UpperLipRoot_000 = 0x4ED2,
    FB_UpperLip_000 = 0xF18F,
    FB_L_Lip_Top_000 = 0x4F37,
    FB_R_Lip_Top_000 = 0x4537,
    FB_Jaw_000 = 0xB4A0,
    FB_LowerLipRoot_000 = 0x4324,
    FB_LowerLip_000 = 0x508F,
    FB_L_Lip_Bot_000 = 0xB93B,
    FB_R_Lip_Bot_000 = 0xC33B,
    FB_Tongue_000 = 0xB987,
    RB_Neck_1 = 0x8B93,
    SKEL_Neck_2 = 0x5FD4,
    FACIAL_jaw = 0xB21,
    FACIAL_underChin = 0x8A95,
    FACIAL_L_underChin = 0x234E,
    FACIAL_chin = 0xB578,
    FACIAL_chinSkinBottom = 0x98BC,
    FACIAL_L_chinSkinBottom = 0x3E8F,
    FACIAL_R_chinSkinBottom = 0x9E8F,
    FACIAL_tongueA = 0x4A7C,
    FACIAL_tongueB = 0x4A7D,
    FACIAL_tongueC = 0x4A7E,
    FACIAL_tongueD = 0x4A7F,
    FACIAL_tongueE = 0x4A80,
    FACIAL_L_tongueE = 0x35F2,
    FACIAL_R_tongueE = 0x2FF2,
    FACIAL_L_tongueD = 0x35F1,
    FACIAL_R_tongueD = 0x2FF1,
    FACIAL_L_tongueC = 0x35F0,
    FACIAL_R_tongueC = 0x2FF0,
    FACIAL_L_tongueB = 0x35EF,
    FACIAL_R_tongueB = 0x2FEF,
    FACIAL_L_tongueA = 0x35EE,
    FACIAL_R_tongueA = 0x2FEE,
    FACIAL_chinSkinTop = 0x7226,
    FACIAL_L_chinSkinTop = 0x3EB3,
    FACIAL_chinSkinMid = 0x899A,
    FACIAL_L_chinSkinMid = 0x4427,
    FACIAL_L_chinSide = 0x4A5E,
    FACIAL_R_chinSkinMid = 0xF5AF,
    FACIAL_R_chinSkinTop = 0xF03B,
    FACIAL_R_chinSide = 0xAA5E,
    FACIAL_R_underChin = 0x2BF4,
    FACIAL_L_lipLowerSDK = 0xB9E1,
    FACIAL_L_lipLowerAnalog = 0x244A,
    FACIAL_L_lipLowerThicknessV = 0xC749,
    FACIAL_L_lipLowerThicknessH = 0xC67B,
    FACIAL_lipLowerSDK = 0x7285,
    FACIAL_lipLowerAnalog = 0xD97B,
    FACIAL_lipLowerThicknessV = 0xC5BB,
    FACIAL_lipLowerThicknessH = 0xC5ED,
    FACIAL_R_lipLowerSDK = 0xA034,
    FACIAL_R_lipLowerAnalog = 0xC2D9,
    FACIAL_R_lipLowerThicknessV = 0xC6E9,
    FACIAL_R_lipLowerThicknessH = 0xC6DB,
    FACIAL_nose = 0x20F1,
    FACIAL_L_nostril = 0x7322,
    FACIAL_L_nostrilThickness = 0xC15F,
    FACIAL_noseLower = 0xE05A,
    FACIAL_L_noseLowerThickness = 0x79D5,
    FACIAL_R_noseLowerThickness = 0x7975,
    FACIAL_noseTip = 0x6A60,
    FACIAL_R_nostril = 0x7922,
    FACIAL_R_nostrilThickness = 0x36FF,
    FACIAL_noseUpper = 0xA04F,
    FACIAL_L_noseUpper = 0x1FB8,
    FACIAL_noseBridge = 0x9BA3,
    FACIAL_L_nasolabialFurrow = 0x5ACA,
    FACIAL_L_nasolabialBulge = 0xCD78,
    FACIAL_L_cheekLower = 0x6907,
    FACIAL_L_cheekLowerBulge1 = 0xE3FB,
    FACIAL_L_cheekLowerBulge2 = 0xE3FC,
    FACIAL_L_cheekInner = 0xE7AB,
    FACIAL_L_cheekOuter = 0x8161,
    FACIAL_L_eyesackLower = 0x771B,
    FACIAL_L_eyeball = 0x1744,
    FACIAL_L_eyelidLower = 0x998C,
    FACIAL_L_eyelidLowerOuterSDK = 0xFE4C,
    FACIAL_L_eyelidLowerOuterAnalog = 0xB9AA,
    FACIAL_L_eyelashLowerOuter = 0xD7F6,
    FACIAL_L_eyelidLowerInnerSDK = 0xF151,
    FACIAL_L_eyelidLowerInnerAnalog = 0x8242,
    FACIAL_L_eyelashLowerInner = 0x4CCF,
    FACIAL_L_eyelidUpper = 0x97C1,
    FACIAL_L_eyelidUpperOuterSDK = 0xAF15,
    FACIAL_L_eyelidUpperOuterAnalog = 0x67FA,
    FACIAL_L_eyelashUpperOuter = 0x27B7,
    FACIAL_L_eyelidUpperInnerSDK = 0xD341,
    FACIAL_L_eyelidUpperInnerAnalog = 0xF092,
    FACIAL_L_eyelashUpperInner = 0x9B1F,
    FACIAL_L_eyesackUpperOuterBulge = 0xA559,
    FACIAL_L_eyesackUpperInnerBulge = 0x2F2A,
    FACIAL_L_eyesackUpperOuterFurrow = 0xC597,
    FACIAL_L_eyesackUpperInnerFurrow = 0x52A7,
    FACIAL_forehead = 0x9218,
    FACIAL_L_foreheadInner = 0x843,
    FACIAL_L_foreheadInnerBulge = 0x767C,
    FACIAL_L_foreheadOuter = 0x8DCB,
    FACIAL_skull = 0x4221,
    FACIAL_foreheadUpper = 0xF7D6,
    FACIAL_L_foreheadUpperInner = 0xCF13,
    FACIAL_L_foreheadUpperOuter = 0x509B,
    FACIAL_R_foreheadUpperInner = 0xCEF3,
    FACIAL_R_foreheadUpperOuter = 0x507B,
    FACIAL_L_temple = 0xAF79,
    FACIAL_L_ear = 0x19DD,
    FACIAL_L_earLower = 0x6031,
    FACIAL_L_masseter = 0x2810,
    FACIAL_L_jawRecess = 0x9C7A,
    FACIAL_L_cheekOuterSkin = 0x14A5,
    FACIAL_R_cheekLower = 0xF367,
    FACIAL_R_cheekLowerBulge1 = 0x599B,
    FACIAL_R_cheekLowerBulge2 = 0x599C,
    FACIAL_R_masseter = 0x810,
    FACIAL_R_jawRecess = 0x93D4,
    FACIAL_R_ear = 0x1137,
    FACIAL_R_earLower = 0x8031,
    FACIAL_R_eyesackLower = 0x777B,
    FACIAL_R_nasolabialBulge = 0xD61E,
    FACIAL_R_cheekOuter = 0xD32,
    FACIAL_R_cheekInner = 0x737C,
    FACIAL_R_noseUpper = 0x1CD6,
    FACIAL_R_foreheadInner = 0xE43,
    FACIAL_R_foreheadInnerBulge = 0x769C,
    FACIAL_R_foreheadOuter = 0x8FCB,
    FACIAL_R_cheekOuterSkin = 0xB334,
    FACIAL_R_eyesackUpperInnerFurrow = 0x9FAE,
    FACIAL_R_eyesackUpperOuterFurrow = 0x140F,
    FACIAL_R_eyesackUpperInnerBulge = 0xA359,
    FACIAL_R_eyesackUpperOuterBulge = 0x1AF9,
    FACIAL_R_nasolabialFurrow = 0x2CAA,
    FACIAL_R_temple = 0xAF19,
    FACIAL_R_eyeball = 0x1944,
    FACIAL_R_eyelidUpper = 0x7E14,
    FACIAL_R_eyelidUpperOuterSDK = 0xB115,
    FACIAL_R_eyelidUpperOuterAnalog = 0xF25A,
    FACIAL_R_eyelashUpperOuter = 0xE0A,
    FACIAL_R_eyelidUpperInnerSDK = 0xD541,
    FACIAL_R_eyelidUpperInnerAnalog = 0x7C63,
    FACIAL_R_eyelashUpperInner = 0x8172,
    FACIAL_R_eyelidLower = 0x7FDF,
    FACIAL_R_eyelidLowerOuterSDK = 0x1BD,
    FACIAL_R_eyelidLowerOuterAnalog = 0x457B,
    FACIAL_R_eyelashLowerOuter = 0xBE49,
    FACIAL_R_eyelidLowerInnerSDK = 0xF351,
    FACIAL_R_eyelidLowerInnerAnalog = 0xE13,
    FACIAL_R_eyelashLowerInner = 0x3322,
    FACIAL_L_lipUpperSDK = 0x8F30,
    FACIAL_L_lipUpperAnalog = 0xB1CF,
    FACIAL_L_lipUpperThicknessH = 0x37CE,
    FACIAL_L_lipUpperThicknessV = 0x38BC,
    FACIAL_lipUpperSDK = 0x1774,
    FACIAL_lipUpperAnalog = 0xE064,
    FACIAL_lipUpperThicknessH = 0x7993,
    FACIAL_lipUpperThicknessV = 0x7981,
    FACIAL_L_lipCornerSDK = 0xB1C,
    FACIAL_L_lipCornerAnalog = 0xE568,
    FACIAL_L_lipCornerThicknessUpper = 0x7BC,
    FACIAL_L_lipCornerThicknessLower = 0xDD42,
    FACIAL_R_lipUpperSDK = 0x7583,
    FACIAL_R_lipUpperAnalog = 0x51CF,
    FACIAL_R_lipUpperThicknessH = 0x382E,
    FACIAL_R_lipUpperThicknessV = 0x385C,
    FACIAL_R_lipCornerSDK = 0xB3C,
    FACIAL_R_lipCornerAnalog = 0xEE0E,
    FACIAL_R_lipCornerThicknessUpper = 0x54C3,
    FACIAL_R_lipCornerThicknessLower = 0x2BBA,
    MH_MulletRoot = 0x3E73,
    MH_MulletScaler = 0xA1C2,
    MH_Hair_Scale = 0xC664,
    MH_Hair_Crown = 0x1675,
    FB_R_Ear_000 = 0x6CDF,
    SPR_R_Ear = 0x63B6,
    FB_L_Ear_000 = 0x6439,
    SPR_L_Ear = 0x5B10,
    FB_TongueA_000 = 0x4206,
    FB_TongueB_000 = 0x4207,
    FB_TongueC_000 = 0x4208,  
    FB_L_Brow_Out_001 = 0xE3DB,
    FB_L_Lid_Upper_001 = 0xB2B6,
    FB_L_Eye_001 = 0x62AC,
    FB_L_CheekBone_001 = 0x542E,
    FB_L_Lip_Corner_001 = 0x74AC,
    FB_R_Lid_Upper_001 = 0xAA10,
    FB_R_Eye_001 = 0x6B52,
    FB_R_CheekBone_001 = 0x4B88,
    FB_R_Brow_Out_001 = 0x54C,
    FB_R_Lip_Corner_001 = 0x2BA6,
    FB_Brow_Centre_001 = 0x9149,
    FB_UpperLipRoot_001 = 0x4ED2,
    FB_UpperLip_001 = 0xF18F,
    FB_L_Lip_Top_001 = 0x4F37,
    FB_R_Lip_Top_001 = 0x4537,
    FB_Jaw_001 = 0xB4A0,
    FB_LowerLipRoot_001 = 0x4324,
    FB_LowerLip_001 = 0x508F,
    FB_L_Lip_Bot_001 = 0xB93B,
    FB_R_Lip_Bot_001 = 0xC33B,
    FB_Tongue_001 = 0xB987,
  },   

  ["Brazo izquierdo"] = {
    SKEL_L_Clavicle = 0xFCD9,
    SKEL_L_UpperArm = 0xB1C5,
    SKEL_L_Forearm = 0xEEEB,
    SKEL_L_Hand = 0x49D9,
    SKEL_L_Finger00 = 0x67F2,
    SKEL_L_Finger01 = 0xFF9,
    SKEL_L_Finger02 = 0xFFA,
    SKEL_L_Finger10 = 0x67F3,
    SKEL_L_Finger11 = 0x1049,
    SKEL_L_Finger12 = 0x104A,
    SKEL_L_Finger20 = 0x67F4,
    SKEL_L_Finger21 = 0x1059,
    SKEL_L_Finger22 = 0x105A,
    SKEL_L_Finger30 = 0x67F5,
    SKEL_L_Finger31 = 0x1029,
    SKEL_L_Finger32 = 0x102A,
    SKEL_L_Finger40 = 0x67F6,
    SKEL_L_Finger41 = 0x1039,
    SKEL_L_Finger42 = 0x103A,
    PH_L_Hand = 0xEB95,
    IK_L_Hand = 0x8CBD,
    RB_L_ForeArmRoll = 0xEE4F,
    RB_L_ArmRoll = 0x1470,
    MH_L_Elbow = 0x58B7,
    MH_L_Finger00 = 0x8C63,
    MH_L_FingerBulge00 = 0x5FB8,
    MH_L_Finger10 = 0x8C53,
    MH_L_FingerTop00 = 0xA244,
    MH_L_HandSide = 0xC78A,
    MH_Watch = 0x2738,
    MH_L_Sleeve = 0x933C,
  },

  ["Pierna izquierda"] = {
    SKEL_L_Thigh = 0xE39F,
    SKEL_L_Calf = 0xF9BB,
    SKEL_L_Foot = 0x3779,
    SKEL_L_Toe0 = 0x83C,
    EO_L_Foot = 0x84C5,
    EO_L_Toe = 0x68BD,
    IK_L_Foot = 0xFEDD,
    PH_L_Foot = 0xE175,
    MH_L_Knee = 0xB3FE,
    RB_L_ThighRoll = 0x5C57,
    MH_L_CalfBack = 0x1013,
    MH_L_ThighBack = 0x600D,
    SM_L_Skirt = 0xC419,
    SM_L_BackSkirtRoll = 0x40B2,
    SM_L_FrontSkirtRoll = 0x9B69,
    SKEL_L_Toe1 = 0x1D6B,
  },

  ["Pierna derecha"] = {
    SKEL_R_Thigh = 0xCA72,
    SKEL_R_Calf = 0x9000,
    SKEL_R_Foot = 0xCC4D,
    SKEL_R_Toe0 = 0x512D,
    EO_R_Foot = 0x1096,
    EO_R_Toe = 0x7163,
    IK_R_Foot = 0x8AAE,
    PH_R_Foot = 0x60E6,
    MH_R_Knee = 0x3FCF,
    RB_R_ThighRoll = 0x192A,
    MH_R_CalfBack = 0xB013,
    MH_R_ThighBack = 0x51A3,
    SM_R_Skirt = 0x7712,
    SM_R_BackSkirtRoll = 0xC141,
    SM_R_FrontSkirtRoll = 0x86F1,
    SKEL_R_Toe1 = 0xB23F,
  },

  ["Brazo derecho"] = {
    SKEL_R_Clavicle = 0x29D2,
    SKEL_R_UpperArm = 0x9D4D,
    SKEL_R_Forearm = 0x6E5C,
    SKEL_R_Hand = 0xDEAD,
    SKEL_R_Finger00 = 0xE5F2,
    SKEL_R_Finger01 = 0xFA10,
    SKEL_R_Finger02 = 0xFA11,
    SKEL_R_Finger10 = 0xE5F3,
    SKEL_R_Finger11 = 0xFA60,
    SKEL_R_Finger12 = 0xFA61,
    SKEL_R_Finger20 = 0xE5F4,
    SKEL_R_Finger21 = 0xFA70,
    SKEL_R_Finger22 = 0xFA71,
    SKEL_R_Finger30 = 0xE5F5,
    SKEL_R_Finger31 = 0xFA40,
    SKEL_R_Finger32 = 0xFA41,
    SKEL_R_Finger40 = 0xE5F6,
    SKEL_R_Finger41 = 0xFA50,
    SKEL_R_Finger42 = 0xFA51,
    PH_R_Hand = 0x6F06,
    IK_R_Hand = 0x188E,
    RB_R_ForeArmRoll = 0xAB22,
    RB_R_ArmRoll = 0x90FF,
    MH_R_Elbow = 0xBB0,
    MH_R_Finger00 = 0x2C63,
    MH_R_FingerBulge00 = 0x69B8,
    MH_R_Finger10 = 0x2C53,
    MH_R_FingerTop00 = 0xEF4B,
    MH_R_HandSide = 0x68FB,
    MH_R_Sleeve = 0x92DC, 
    SM_Torch = 0x8D6,
    FX_Light = 0x8959,
    FX_Light_Scale = 0x5038,
    FX_Light_Switch = 0xE18E,
    MH_R_ShoulderBladeRoot = 0x3A0A,
    MH_R_ShoulderBlade = 0x54AF,

    MH_L_ShoulderBladeRoot = 0x8711,
    MH_L_ShoulderBlade = 0x4EAF,
  },
}

--[[ 
--======================================================================
--=========================PARADA CARDÍACA==============================
--======================================================================

function doParada()
    if not(dead) and health >= 1 then 
      state = "PARADA CARDÍACA"
      if inconsciente == true then 
      	inconsciente = false 
      end
      tick = 180
      parada = true
    end
    while parada do
        Citizen.Wait(0)
        StartScreenEffect('DeathFailOut',  0,  false)
        drawTxt("~r~Morirás en ~b~3 minutos~r~ si no te realizan un RCP",7, 1, 0.5, 0.55, 0.5,255,0,0,255)

        SetTextFont(7)
        SetTextProportional(0)
        SetTextScale(0.0, 1.5)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)

        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")

        local text = "Parada cardíaca"
        

        AddTextComponentString(text)
        SetTextCentre(true)
        DrawText(0.5, 0.4)
        SetPedToRagdoll(GetPlayerPed(-1),1000, 1000, 0,0,0,0)

        timer = true
        if tick <= 0 then 
        	SetEntityHealth(GetPlayerPed(-1), 0)
        	parada = false
        end
    end
end
--]]

--[[ 
function OnPlayerDeath()
    ShowTimer()
    pulse = 0
end

Citizen.CreateThread(function()
  local i = 0
  while true do
    Citizen.Wait(2000)
    TriggerEvent('pop_voice:dead',dead)
    if dead == true then
      i =  i + 2
    end

    if i == 30 then
      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      instantRevive(playerPed, {
        x = coords.x,
        y = coords.y,
        z = coords.z
      })

      i = 0
    end
  end
end)

Citizen.CreateThread(function()
  Citizen.Wait(500)  
  while true do
    Citizen.Wait(0)  
    if dead == true or inconsciente == true then
      if IsControlJustPressed(1,289) then
        ESX.UI.Menu.CloseAll()
      end
    end
  end
end)

function instantRevive(ped, coords)
  NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
  SetEntityHealth(ped, 0)
end

function ShowTimer()
  local timer = 1 * minute
  StartScreenEffect('DeathFailOut',  0,  false)
  Citizen.CreateThread(function()

    while timer > 0 and dead do
            Wait(0)

      raw_seconds = timer/1000
      raw_minutes = raw_seconds/60
      minutes = stringsplit(raw_minutes, ".")[1]
      seconds = stringsplit(raw_seconds-(minutes*60), ".")[1]

          drawTxt("Has muerto",7, 1, 0.5, 0.5, 1.5,255,0,0,255)
            SetTextFont(4)
            SetTextProportional(0)
            SetTextScale(0.0, 0.5)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(0, 0, 0, 0, 255)
            SetTextEdge(1, 0, 0, 0, 255)

            SetTextDropShadow()
            SetTextOutline()
            SetTextEntry("STRING")

            local text = 'Por favor, espere ~b~' .. minutes .. ' minutos ' .. seconds .. ' segundos ~w~para reparecer.'

            AddTextComponentString(text)
            SetTextCentre(true)
            DrawText(0.5, 0.8)

            timer = timer - 15
    end
    if timer == 0 then 
      RemoveItemsAfterRPDeath()
    end
  end)
end

function RemoveItemsAfterRPDeath()
    Citizen.CreateThread(function()
        DoScreenFadeOut(800)
        while not IsScreenFadedOut() do
            Citizen.Wait(0)
        end
        ESX.TriggerServerCallback('esx_ambulancejob:removeItemsAfterRPDeath', function()

            ESX.SetPlayerData('lastPosition', {x = 285.45, y = -580.8, z = 43.37})
            ESX.SetPlayerData('loadout', {})

            TriggerServerEvent('esx:updateLastPosition', {x = 285.45, y = -580.8, z = 43.37})

            RespawnPed(GetPlayerPed(-1), {x = 285.45, y = -580.8, z = 43.37})

            StopScreenEffect('DeathFailOut')
            DoScreenFadeIn(800)
        end)
    end)
end

function RespawnPed(ped, coords)
  SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
  NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.heading, true, false)
  SetPlayerInvincible(ped, false)
  TriggerEvent('playerSpawned', coords.x, coords.y, coords.z, coords.heading)
  ClearPedBloodDamage(ped)
  if RespawnToHospitalMenu ~= nil then
    RespawnToHospitalMenu.close()
    RespawnToHospitalMenu = nil
  end
  ESX.UI.Menu.CloseAll()
end
--]]

--                ----- SPAWN -----     

	--[[
	if FirstSpawn == true then 
		SetPlayerInvincible(PlayerId(), true)
		Wait(5000)
		SetPlayerInvincible(PlayerId(), false)
	end
	SetEntityHealth(GetPlayerPed(-1), 200)
	]]

	    --[[
    if health == 0 or dead == true then 
    	TriggerEvent('esx_ambulancejob:revive')
    end
    if bleeding >= 1 then 
    	bleeding = 0 
    end
    ]]

    --[[
    local b = true 
    Citizen.Wait(5000)
    local b = false
    if --[[parada == true or inconsciente == true or dead == true or health == 0 then 
    	parada = false
    	inconsciente = false
    	dead = false 
    	SetEntityHealth(GetPlayerPed(-1), 200)
    	StopScreenEffect('DeathFailOut',  0,  false)
		ClearTimecycleModifier()
		ResetPedMovementClipset(GetPlayerPed(-1), 0) 
		SetPedMoveRateOverride(PlayerId(), 1.0)
		bones = {
		  Torso = {dmg = 0, gravedad = 0},
		  Cabeza = {dmg = 0, gravedad = 0},
		  Pizq = {dmg = 0, gravedad = 0},
		  Pder = {dmg = 0, gravedad = 0},
		  Bizq = {dmg = 0, gravedad = 0}, 
		  Bder = {dmg = 0, gravedad = 0}
		}
	end
	]]