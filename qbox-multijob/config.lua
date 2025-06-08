Config = {}

-- Default job when off duty
Config.DefaultJob = 'unemployed'

-- Grade level used for new hires and when going off duty
Config.DefaultGrade = 0

-- Jobs are taken from qb-core's shared list so they do not need to be listed
-- here. Only players with entries in the employment table can switch to them.

-- Database table that keeps track of employment
Config.EmploymentTable = 'multijob_employment'