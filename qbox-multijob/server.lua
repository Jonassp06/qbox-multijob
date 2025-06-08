local QBCore = exports['qb-core']:GetCoreObject()

-- ensure the employment table and grade column exist
MySQL.query.await(([[
CREATE TABLE IF NOT EXISTS `%s` (
  `citizenid` VARCHAR(50) NOT NULL,
  `job` VARCHAR(50) NOT NULL,
  `grade` TINYINT UNSIGNED NOT NULL DEFAULT %d,
  PRIMARY KEY (`citizenid`, `job`)
);
]]):format(Config.EmploymentTable, Config.DefaultGrade))

local gradeCheck = MySQL.query.await(('SHOW COLUMNS FROM `%s` LIKE "grade"'):format(Config.EmploymentTable))
if not gradeCheck or #gradeCheck == 0 then
    MySQL.query.await(('ALTER TABLE `%s` ADD COLUMN `grade` TINYINT UNSIGNED NOT NULL DEFAULT %d'):format(Config.EmploymentTable, Config.DefaultGrade))
end

local function getEmployment(cid)
    local result = MySQL.query.await(
        ('SELECT job, grade FROM %s WHERE citizenid = ?'):format(Config.EmploymentTable),
        { cid }
    ) or {}

    local jobs = {}
    for _, row in ipairs(result) do
        jobs[row.job] = tonumber(row.grade) or Config.DefaultGrade
    end
    return jobs
end

lib.callback.register('qbox-multijob:getAllowedJobs', function(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return {} end

    local employment = getEmployment(Player.PlayerData.citizenid)
    local allowed = {}

    for jobName, jobData in pairs(QBCore.Shared.Jobs) do
        if employment[jobName] then
            allowed[#allowed+1] = {
                name = jobName,
                label = jobData.label
            }
        end
    end

    return allowed
end)

RegisterNetEvent('qbox-multijob:setJob', function(jobName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local employment = getEmployment(Player.PlayerData.citizenid)

    if jobName == Config.DefaultJob then
        local curJob = Player.PlayerData.job
        if curJob.name ~= Config.DefaultJob then
            MySQL.insert.await(
                ('INSERT INTO %s (citizenid, job, grade) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE grade = VALUES(grade)'):format(Config.EmploymentTable),
                { Player.PlayerData.citizenid, curJob.name, curJob.grade.level }
            )
        end
        Player.Functions.SetJob(Config.DefaultJob, Config.DefaultGrade)
    else
        local grade = employment[jobName]
        if not grade then
            print(('Unauthorized job change to %s attempted by %s'):format(jobName, src))
            return
        end
        Player.Functions.SetJob(jobName, grade)
    end

    TriggerClientEvent('QBCore:Client:OnJobUpdate', src, Player.PlayerData.job)
end)

RegisterNetEvent('qbox-multijob:hire', function(targetId, jobName, grade)
    if not targetId or not jobName then return end
    local target = QBCore.Functions.GetPlayer(targetId)
    if not target then return end

    local insertGrade = tonumber(grade) or Config.DefaultGrade
    MySQL.insert.await(
        ('INSERT INTO %s (citizenid, job, grade) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE grade = VALUES(grade)'):format(Config.EmploymentTable),
        { target.PlayerData.citizenid, jobName, insertGrade }
    )
end)

RegisterNetEvent('qbox-multijob:fire', function(targetId, jobName)
    if not targetId or not jobName then return end
    local target = QBCore.Functions.GetPlayer(targetId)
    if not target then return end

    MySQL.execute.await(
        ('DELETE FROM %s WHERE citizenid = ? AND job = ?'):format(Config.EmploymentTable),
        { target.PlayerData.citizenid, jobName }
    )
end)