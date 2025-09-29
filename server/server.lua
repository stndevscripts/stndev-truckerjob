local ESX = exports.es_extended:getSharedObject()
local lastRewardTime = {}

RegisterServerEvent('stndev:giveReward')
AddEventHandler('stndev:giveReward', function(amount, jobName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    -- Anti-abuse: cooldown check (30s)
    local now = os.time()
    if lastRewardTime[src] and (now - lastRewardTime[src]) < 30 then
        print(('[STNDEV] ABUSE DETECTED from %s [%s]'):format(xPlayer.getName(), src))
        return
    end

    -- Basic validation
    if type(amount) ~= 'number' or amount < 0 or amount > 100000 then return end
    if type(jobName) ~= 'string' then return end

    local valid = false
    for _, job in ipairs(Config.Jobs) do
        if job.name == jobName then
            valid = true
            break
        end
    end

    if not valid then
        print(('[STNDEV] Player %s tried to trigger invalid job reward: %s'):format(src, jobName))
        return
    end

    lastRewardTime[src] = now
    xPlayer.addMoney(amount)
end)

RegisterServerEvent('stndev:logJobStart')
AddEventHandler('stndev:logJobStart', function(jobName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local webhook = Config.Webhooks.jobStarted
    if not webhook or webhook == '' then return end

    local embed = {
        {
            title = '🚚 Trucker Job Started',
            color = 16753920,
            fields = {
                { name = 'Player', value = xPlayer.getName(), inline = true },
                { name = 'Job', value = jobName, inline = true }
            },
            footer = { text = 'StnDev Trucker System' },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }
    }

    PerformHttpRequest(webhook, function() end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('stndev:logJobComplete')
AddEventHandler('stndev:logJobComplete', function(jobName, reward)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    local webhook = Config.Webhooks.jobCompleted
    if not webhook or webhook == '' then return end

    local embed = {
        {
            title = '✅ Trucker Job Completed',
            color = 65280,
            fields = {
                { name = 'Player', value = xPlayer.getName(), inline = true },
                { name = 'Job', value = jobName, inline = true },
                { name = 'Reward', value = '$' .. reward, inline = true }
            },
            footer = { text = 'StnDev Trucker System' },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ')
        }
    }

    PerformHttpRequest(webhook, function() end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end)
