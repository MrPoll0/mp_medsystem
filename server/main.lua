ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('medSys:init')
AddEventHandler('medSys:init', function(value)
  if value == 0 then
    print('[medSys] Cargando el jugador: '..GetPlayerName(source))
    TriggerClientEvent('medSys:loading', source)
  end
  if value == 1 then 
    print('[medSys] Jugador cargado: '..GetPlayerName(source))
  end
end)

RegisterServerEvent('medSys:getJob')
AddEventHandler('medSys:getJob',function()
  local source = source
  local xPlayers = ESX.GetPlayers()
  for i=1, #xPlayers, 1 do
    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
    if xPlayers[i] == source then
      TriggerClientEvent('medSys:setJob',xPlayers[i],xPlayer.job.name)
    end
  end
end)

RegisterServerEvent('medSys:saveData')
AddEventHandler('medSys:saveData', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local jsData = json.encode(data)
  MySQL.Sync.execute('UPDATE users SET medData=@medData WHERE identifier=@identifier',{['@medData'] = jsData,['@identifier'] = xPlayer.identifier})
end)

ESX.RegisterServerCallback('medSys:GetData', function(source, cb)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do 
    Citizen.Wait(0)
    ESX.GetPlayerFromId(source)
  end

  local cbData = false
  local data = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier})
  if not data or not data[1] or not data[1].medData then 
  	cbData = false
  else 
  	cbData = json.decode(data[1].medData)
  end
  cb(cbData)
end)

ESX.RegisterServerCallback('medSys:GetOtherData', function(source, cb, target)
  local xPlayer = ESX.GetPlayerFromId(target)
  while not xPlayer do 
    Citizen.Wait(0) 
    ESX.GetPlayerFromId(target) 
  end

  local cbData = false
  local data = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier=@identifier",{['@identifier'] = xPlayer.identifier})
  if not data or not data[1] or not data[1].medData then 
    cbData = false
  else 
    cbData = json.decode(data[1].medData)
  end
  cb(cbData)
end)

RegisterServerEvent('medSys:healOther')
AddEventHandler('medSys:healOther', function (target, med,zone)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  --xPlayer.removeInventoryItem(item,1)

  TriggerClientEvent('medSys:ChealOtherMedic',source,med)
  TriggerClientEvent('medSys:ChealOther',target,med,zone)
end)

ESX.RegisterServerCallback('medSys:removeItem', function(source, cb, item)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer then
    local quantityItem = xPlayer.getInventoryItem(item)
    if quantityItem.count >= 1 then
      xPlayer.removeInventoryItem(item,1)
      cb(true)
    else
      if item ~= 'venda_compresiva' and item ~= 'bolsa_de_sangre' then
        TriggerClientEvent('esx:showNotification', source, 'No tienes suficiente '..item..'.')
      elseif item == 'venda_compresiva' then 
        TriggerClientEvent('esx:showNotification', source, 'No tienes suficientes vendas compresivas.')
      elseif item == 'bolsa_de_sangre' then 
        TriggerClientEvent('esx:showNotification', source, 'No tienes suficientes bolsas de sangre.')
      end
      cb(false)
    end
  end
end)

RegisterServerEvent('medSys:buyItem')
AddEventHandler('medSys:buyItem',function(item, price)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer then
    if (price <= xPlayer.getMoney()) then
      xPlayer.removeMoney(price)
      xPlayer.addInventoryItem(item,1)
      if item ~= 'venda_compresiva' and item ~= 'bolsa_de_sangre' then
        TriggerClientEvent('esx:showNotification', source, 'Has comprado '..item)
      elseif item == 'venda_compresiva' then 
        TriggerClientEvent('esx:showNotification', source, 'Has comprado venda compresiva')
      elseif item == 'bolsa_de_sangre' then 
        TriggerClientEvent('esx:showNotification', source, 'Has comprado bolsa de sangre')
      end
    else

      TriggerClientEvent('esx:showNotification', source, 'No tienes suficiente dinero')
    end
  end
end)