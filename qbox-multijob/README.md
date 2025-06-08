Jonassp06/Jonassp06 is a ✨ special ✨ repository because its `README.md` (this file) appears on your GitHub profile.
You can click the Preview link to take a look at your changes.
--->
## Qbox MultiJob

This repository includes a small example script for **Qbox** servers using `ox_lib`. The script lets players switch between multiple jobs or go off duty using a context menu. The resource can be found in the `qbox-multijob` folder.

Available jobs are read directly from `qb-core`'s shared jobs list. Players only see jobs they are currently employed in, which are stored in the database.

Players may only change to jobs they are currently employed in. Employment information is stored in the `multijob_employment` database table (see `qbox-multijob/multijob.sql`). Other resources can manage employment by triggering the events `qbox-multijob:hire` and `qbox-multijob:fire`.

Each employment record also stores the employee's job grade (using the numeric level from **qb-core**). When a player goes off duty their current grade is saved so returning to the job restores the same grade.

The server script will automatically create the `multijob_employment` table if it doesn't exist and add the `grade` column for older installations. You can also apply `multijob.sql` manually if you prefer.

```lua
TriggerEvent('qbox-multijob:hire', playerId, 'police', 4) -- hire or update with grade 4
TriggerEvent('qbox-multijob:fire', playerId, 'police')
```
