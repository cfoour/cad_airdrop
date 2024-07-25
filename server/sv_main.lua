local config = lib.load('config.server')

-- Item Handler
RegisterNetEvent('cad_airdrop:server:ItemHandler', function(kind, item, count)
    local src = source
    --if not src then return end
    if kind == 'add' then
        exports.ox_inventory:AddItem(src, item, count)
    elseif kind == 'remove' then
        exports.ox_inventory:RemoveItem(src, item, count)
    end
end)

-- get amount of cops online and on duty
lib.callback.register('cad_airdrop:server:getCops', function(source)
    local count = 0
    for i = 1, #config.policeJobs do
        local job = config.policeJobs[i]
        local amount = exports.qbx_core:GetDutyCountJob(job)
        count = count + amount
    end
    Wait(100)
    return count
end)
 
-- Golden Satalite Phone
exports.qbx_core:CreateUseableItem('goldenphone', function(source, item)
    TriggerClientEvent('cad_airdrop:client:CreateDrop', source, tostring(item.name), true, 400)
    exports.ox_inventory:RemoveItem(source, 'goldenphone', 1)
end)

-- Red Satellite Phone
exports.qbx_core:CreateUseableItem('redphone', function(source, item)
    TriggerClientEvent('cad_airdrop:client:CreateDrop', source, tostring(item.name), true, 400)
    exports.ox_inventory:RemoveItem(source, 'redphone', 1)
end)

-- Green Satellite Phone
exports.qbx_core:CreateUseableItem('greenphone', function(source, item)
    TriggerClientEvent('cad_airdrop:client:CreateDrop', source, tostring(item.name), true, 400)
    exports.ox_inventory:RemoveItem(source, 'greenphone', 1)
end)
