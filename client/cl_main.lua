local config = lib.load('config.client')

local pilot, aircraft, parachute, crate, soundID

function SendNotify( msg, type)
    lib.notify({
        title = 'Air Drop',
        description = msg,
        type = type
    })
end

-- reward on open crate
function OpenCrate(crate, item, amount)
    lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        label = 'Searching For Items',
        useWhileDead = false,
        allowCuffed = false,
        allowFalling = false,
        canCancel = false,
        disable = {car = true, move = true, combat = true},
    })
    TriggerServerEvent('cad_airdrop:server:ItemHandler', 'add', item, amount)
    exports.interact:RemoveEntityInteraction(crate, 'crate_id')
    DeleteEntity(crate)
    SendNotify(('%s %sx %s'):format(locale('info.item_recieved'), amount, item), 'info')
end

-- Crate Drop function
function CrateDrop(item, amount, planeSpawnDistance, dropCoords)
    CreateThread(function()
        SendNotify(locale('success.pilot_dropping_soon'), 'success') -- Notify the pilot that we are preparing the crate with the plane
        SetTimeout(config.timeUntilDrop, function()
            for i = 1, #config.loadModels do
                lib.requestModel(config.loadModels[i])
            end
            lib.requestAnimDict(config.parachuteModel)

            lib.requestWeaponAsset((config.flareName))

            local rHeading = math.random(0, 360) + 0.0
            local planeSpawnDistance = (planeSpawnDistance and tonumber(planeSpawnDistance) + 0.0) or 400.0
            local theta = (rHeading / 180.0) * 3.14
            local rPlaneSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z) -
            vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -500.0)
            local dx = dropCoords.x - rPlaneSpawn.x
            local dy = dropCoords.y - rPlaneSpawn.y
            local heading = GetHeadingFromVector_2d(dx, dy)
            aircraft = CreateVehicle(joaat(config.planeModel), rPlaneSpawn, heading, true, true)
            SetEntityHeading(aircraft, heading)
            SetVehicleDoorsLocked(aircraft, 2)
            SetEntityDynamic(aircraft, true)
            ActivatePhysics(aircraft)
            SetVehicleForwardSpeed(aircraft, 60.0)
            SetHeliBladesFullSpeed(aircraft)
            SetVehicleEngineOn(aircraft, true, true, false)
            ControlLandingGear(aircraft, 3)
            OpenBombBayDoors(aircraft)
            SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)
            pilot = CreatePedInsideVehicle(aircraft, 1, joaat(config.planePilotModel), -1, true, true)
            SetBlockingOfNonTemporaryEvents(pilot, true)
            SetPedRandomComponentVariation(pilot, false)
            SetPedKeepTask(pilot, true)
            SetPlaneMinHeightAboveTerrain(aircraft, 50)
            TaskVehicleDriveToCoord(pilot, aircraft, vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), 60.0, 0, joaat(config.planeModel), 262144, 15.0, -1.0)                                                                                                                             -- to the dropsite, could be replaced with a task sequence
            local dropArea = vector2(dropCoords.x, dropCoords.y)
            local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
            while not IsEntityDead(pilot) and #(planeLocation - dropArea) > 5.0 do
                planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
                Wait(100)
            end
            if IsEntityDead(pilot) then
                SendNotify(locale('error.pilot_crashed'), 'error') -- Notify the pilot that the plane has crashed
                return
            end
            TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0, joaat(config.planeModel), 262144, -1.0, -1.0)
            SetEntityAsNoLongerNeeded(pilot)
            SetEntityAsNoLongerNeeded(aircraft)
            SendNotify(locale('success.crate_dropping'), 'success') -- Notify the pilot that we are preparing the crate with the plane
            local crateSpawn = vector3(dropCoords.x, dropCoords.y, GetEntityCoords(aircraft).z - 5.0)
            crate = CreateObject(config.crateModel, crateSpawn, true, true, true)
            SetEntityLodDist(crate, 1000)
            ActivatePhysics(crate)
            SetDamping(crate, 2, 0.1)
            SetEntityVelocity(crate, 0.0, 0.0, -0.2)
            parachute = CreateObject(config.parachuteModel, crateSpawn, true, true, true)
            SetEntityLodDist(parachute, 1000)
            SetEntityVelocity(parachute, 0.0, 0.0, -0.2)
            AttachEntityToEntity(parachute, crate, 0, 0.0, 0.0, 0.1, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            -- Sound
            soundID = GetSoundId()
            PlaySoundFromEntity(soundID, 'Crate_Beeps', parachute, 'MP_CRATE_DROP_SOUNDS', true, 0)
            -- Checks when the crate is at the dropsite and delete the parachute
            local parachuteCoords = vector3(GetEntityCoords(parachute))
            while #(parachuteCoords - dropCoords) > 5.0 do
                parachuteCoords = vector3(GetEntityCoords(parachute))
                Wait(100)
            end
            ShootSingleBulletBetweenCoords(dropCoords, dropCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, joaat(config.flareName), 0, true, false, -1.0)
            DetachEntity(parachute, true, true)
            DeleteEntity(parachute)
            StopSound(soundID)
            ReleaseSoundId(soundID)
            for i = 1, #config.loadModels do
                SetModelAsNoLongerNeeded(joaat(config.loadModels[i]))
                Wait(0)
            end
            RemoveWeaponAsset(config.flareName)

            -- exports.ox_target:addLocalEntity(crate, {
            --     {
            --         icon = 'fas fa-box-open',
            --         name = 'crate_id',
            --         label = 'Open Crate',
            --         onSelect = function(entity)
            --             OpenCrate(crate, item, amount)
            --         end,
            --     }
            -- })

            exports.interact:AddEntityInteraction({
                netId = ObjToNet(crate),
                id = 'crate_id',
                ignoreLos = true,
                distance = 5.0,
                interactDst = 1.5,
                options = {
                    {
                        label = 'Open Crate',
                        action = function()
                            OpenCrate(crate, item, amount)
                        end
                    }
                }
            })
        end)
    end)
end

-- notify police functions
function PoliceAlert()
    -- put your own dispatch here and comment the below event
    exports['ps-dispatch']:DrugSale()
end

-- Give random item from given list of the item used
function GetRandomItemData(item)
    if config.itemDrops[item] then
        local Items = config.itemDrops[item]
        local randomItem = Items[math.random(#Items)]
        return randomItem['name'], randomItem['amount']
    end
end

-- Start the AirDrop
RegisterNetEvent('cad_airdrop:client:StartDrop', function(item, amount, roofCheck, planeSpawnDistance, dropCoords)
    CreateThread(function()
        if dropCoords.x and dropCoords.y and dropCoords.z and tonumber(dropCoords.x) and tonumber(dropCoords.y) and tonumber(dropCoords.z) then
        else
            dropCoords = { 0.0, 0.0, 72.0 }
        end
        lib.requestWeaponAsset(config.flareName)

        ShootSingleBulletBetweenCoords(GetEntityCoords(cache.ped),GetEntityCoords(cache.ped) - vector3(0.0001, 0.0001, 0.0001), 0, false, joaat(config.flareName), 0, true, false, -1.0)
        if roofCheck and roofCheck ~= 'false' then
            local ray = StartShapeTestRay(vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 500.0), vector3(dropCoords.x, dropCoords.y, dropCoords.z), -1, -1, 0)
            local _, hit, impactCoords = GetShapeTestResult(ray)
            if hit == 0 or (hit == 1 and #(vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(impactCoords)) < 10.0) then
                CrateDrop(item, amount, planeSpawnDistance, dropCoords)
            else
                return
            end
        else
            CrateDrop(item, amount, planeSpawnDistance, dropCoords)
        end
    end)
end)

-- Create the AirDrop
RegisterNetEvent('cad_airdrop:client:CreateDrop', function(item, roofCheck, planeSpawnDistance)
    local playerCoords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 10.0, 0.0)
    local item, amount = GetRandomItemData(item)
    local currentCops = lib.callback.await('cad_airdrop:server:getCops', false)
    if currentCops >= config.requiredCops then
        SendNotify(locale('success.contacted_mafia'), 'success')
        SendNotify(locale('success.pilot_contact'), 'success')
        PoliceAlert()
        TriggerEvent('cad_airdrop:client:StartDrop', item, amount, roofCheck or false, planeSpawnDistance or 400.0, vector3(playerCoords.x, playerCoords.y, playerCoords.z))
        --TriggerServerEvent('cad_airdrop:server:ItemHandler', 'remove', item, 1)
    else
        SendNotify(locale('error.no_cops'), 'error')
    end
end)

-- On resource stop do things
AddEventHandler('onResourceStop', function(resource)
    if resource ~= cache.resource then return end
    SetEntityAsMissionEntity(pilot, false, true)
    DeleteEntity(pilot)
    SetEntityAsMissionEntity(aircraft, false, true)
    DeleteEntity(aircraft)
    DeleteEntity(parachute)
    DeleteEntity(crate)
    RemovePickup(pickup)
    RemoveBlip(blip)
    StopSound(soundID)
    ReleaseSoundId(soundID)
    for i = 1, #config.loadModels do
        SetModelAsNoLongerNeeded(joaat(config.loadModels[i]))
        Wait(0)
    end
end)
