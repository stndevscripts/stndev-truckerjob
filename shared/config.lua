Config = {}

Config.PedLocation = vector4(503.3978, -2133.7915, 5.9175, 217.5569)

Config.TruckSpawn = vector4(520.9534, -2158.4976, 5.9867, 174.8810)
Config.TrailerSpawn = vector4(514.6461, -2156.5129, 5.9792, 182.0854)

Config.Blip = {
    sprite = 477,
    color = 17,
    label = 'Trucker Job'
}

Config.NotificationType = 'esx' -- 'ox', 'okok', 'esx'

Config.Webhooks = {
    jobStarted = 'https://discord.com/api/webhooks/1422289838723436652/LI-c05MKctXaNYk_KeRlee7NaL-Cm6Ev9ABKJ7bMk36VZNk4oGgGLWQtcD8YJ4Ijliip',
    jobCompleted = 'https://discord.com/api/webhooks/1422289956453482640/mP_JR0IyPswygTCftYQBJTgu8QTaXyHB578P0UNq-ucSjw7Zvn3vr0CQ5ne_bWLZTQJo'
}

Config.Jobs = {
    {
        name = 'Refueling Station',
        coords = vector4(128.4524, 6604.4751, 31.8640, 222.2107),
        reward = {min = 2500, max = 5000},
        icon = 'fa-solid fa-gas-pump'
    },
    {
        name = 'Youtool',
        coords = vector4(2670.6531, 3517.7905, 52.6971, 336.6649),
        reward = {min = 1500, max = 3500},
        icon = 'fa-solid fa-toolbox'
    },
    {
        name = 'Clucking Bell',
        coords = vector4(34.7365, 6289.2490, 31.2421, 292.9419),
        reward = {min = 2000, max = 4000},
        icon = 'fa-solid fa-drumstick-bite'
    },
    {
        name = 'Factory',
        coords = vector4(2821.4661, 1674.1271, 24.7250, 354.8048),
        reward = {min = 900, max = 1500},
        icon = 'fa-solid fa-industry'
    }
}
