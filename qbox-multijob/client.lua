local QBCore = exports['qb-core']:GetCoreObject()

local function openJobMenu()
    lib.callback('qbox-multijob:getAllowedJobs', false, function(jobs)
        local menu = {}

        for _, job in ipairs(jobs) do
            menu[#menu + 1] = {
                title = job.label,
                description = ('Switch to %s'):format(job.label),
                onSelect = function()
                    TriggerServerEvent('qbox-multijob:setJob', job.name)
                end
            }
        end

        menu[#menu + 1] = {
            title = 'Go Off Duty',
            description = 'Switch to '..Config.DefaultJob,
            onSelect = function()
                TriggerServerEvent('qbox-multijob:setJob', Config.DefaultJob)
            end
        }

        lib.registerContext({
            id = 'qbox_multijob_menu',
            title = 'Job Menu',
            options = menu
        })

        lib.showContext('qbox_multijob_menu')
    end)
end

RegisterCommand('jobmenu', openJobMenu, false)