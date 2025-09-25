local ESX = exports['es_extended']:getSharedObject()
local currentJob = nil
local completedLocations = {}
local destinationBlip = nil

CreateThread(function()
    local blip = AddBlipForCoord(Config.PedLocation.xyz)
    SetBlipSprite(blip, Config.Blip.sprite)
    SetBlipColour(blip, Config.Blip.color)
    SetBlipScale(blip, 0.9)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.Blip.label)
    EndTextCommandSetBlipName(blip)

    local pedCoords = vector4(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z - 1.0, Config.PedLocation.w)
    RequestModel('s_m_m_trucker_01')
    while not HasModelLoaded('s_m_m_trucker_01') do Wait(0) end
    local ped = CreatePed(0, 's_m_m_trucker_01', pedCoords.xyz, pedCoords.w, false, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_SMOKING', 0, true)

    exports.ox_target:addSphereZone({
        coords = Config.PedLocation.xyz,
        radius = 2.0,
        debug = false,
        options = {
            {
                name = 'trucker_job_menu',
                icon = 'fa-solid fa-truck',
                label = 'View available offers',
                onSelect = function()
                    openJobMenu()
                end
            }
        }
    })
end)

function openJobMenu()
    local options = {}

    for _, job in ipairs(Config.Jobs) do
        if not completedLocations[job.name] then
            options[#options+1] = {
                title = job.name,
                description = ('Reward: $%d - $%d'):format(job.reward.min, job.reward.max),
                icon = job.icon,
                arrow = true,
                onSelect = function()
                    startJob(job)
                end
            }
        end
    end

    lib.registerContext({
        id = 'trucker_job_menu',
        title = 'Available Trucker Jobs',
        options = options
    })

    lib.showContext('trucker_job_menu')
end

function startJob(job)
    currentJob = job

    local truckModel = 'phantom'
    local trailerModel = 'trailers2'

    RequestModel(truckModel)
    RequestModel(trailerModel)
    while not HasModelLoaded(truckModel) or not HasModelLoaded(trailerModel) do Wait(0) end

    local truck = CreateVehicle(truckModel, Config.TruckSpawn.xyz, Config.TruckSpawn.w, true, false)
    local trailer = CreateVehicle(trailerModel, Config.TrailerSpawn.xyz, Config.TrailerSpawn.w, true, false)

    SetPedIntoVehicle(PlayerPedId(), truck, -1)
    SetVehicleOnGroundProperly(truck)
    SetVehicleOnGroundProperly(trailer)

    destinationBlip = AddBlipForCoord(job.coords.xyz)
    SetBlipRoute(destinationBlip, true)
    SetBlipRouteColour(destinationBlip, 5)

    showNotify('Attach the trailer and deliver the cargo to the marked location.', 'inform')

    monitorDelivery(truck, trailer, job)
end

function monitorDelivery(truck, trailer, job)
    CreateThread(function()
        while currentJob do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local dist = #(playerCoords - job.coords.xyz)

            if dist < 50.0 then
                DrawMarker(1, job.coords.x, job.coords.y, job.coords.z - 1.0, 0, 0, 0, 0, 0, 0, 2.5, 2.5, 1.0, 255, 255, 0, 150, false, true, 2, nil, nil, false)
            end

            if dist < 2.5 then
                lib.showTextUI('[E] Deliver cargo')

                if IsControlJustReleased(0, 38) then
                    if GetEntityModel(truck) == GetHashKey('phantom') and IsVehicleAttachedToTrailer(truck) then
                        lib.hideTextUI()
                        lib.progressCircle({
                            duration = 3000,
                            position = 'middle',
                            useWhileDead = false,
                            canCancel = false,
                            label = 'Unloading cargo...',
                        })
                        completeDelivery(truck, trailer)
                        break
                    else
                        showNotify('You must be in the truck and have the trailer attached.', 'error')
                    end
                end
            else
                lib.hideTextUI()
            end

            Wait(0)
        end
    end)
end

function completeDelivery(truck, trailer)
    local reward = math.random(currentJob.reward.min, currentJob.reward.max)

    DeleteVehicle(truck)
    DeleteVehicle(trailer)
    TriggerServerEvent('stndev:giveReward', reward)
    showNotify('The cargo has been successfully delivered, here is your reward.', 'success')

    if destinationBlip then
        RemoveBlip(destinationBlip)
        destinationBlip = nil
    end

    completedLocations[currentJob.name] = true
    currentJob = nil

    Wait(1000)
    askContinue()
end

function askContinue()
    lib.registerContext({
        id = 'trucker_continue_menu',
        title = 'Continue working?',
        options = {
            {
                title = 'Yes',
                icon = 'fa-solid fa-check',
                onSelect = function()
                    openJobMenu()
                end
            },
            {
                title = 'No',
                icon = 'fa-solid fa-xmark',
                onSelect = function()
                    showNotify('You have finished your trucking shift.', 'inform')
                end
            }
        }
    })

    lib.showContext('trucker_continue_menu')
end

function showNotify(text, type)
    if Config.NotificationType == 'ox' then
        lib.notify({description = text, type = type})
    elseif Config.NotificationType == 'okok' then
        exports['okokNotify']:Alert('Trucker Job', text, 5000, type)
    elseif Config.NotificationType == 'esx' then
        ESX.ShowNotification(text)
    end
end