obs = obslua

-- Replace 'UVC Webcam' with the name of your video capture source
local source_name = 'UVC Webcam'

-- The value below (default: 1) is the reload interval in minutes.
-- Change as needed.
local reload_interval_minutes = 1

local function reload_source()
local source = obs.obs_get_source_by_name(source_name)
if source ~= nil then
obs.obs_source_inc_showing(source)
obs.timer_add(function() obs.obs_source_dec_showing(source) end, 500)

-- the value above that says "500" is a 500ms reconnection delay
-- this is because the reload cycle can sometimes fail if there is no delay

-- NOTE: you need to try out and see what works best for you;
-- in some cases you might even be ok with no delay at all.
-- note that this might mean visible dropouts, especially with higher values.

obs.obs_source_release(source)
end
end

local function timer_callback()
reload_source()
obs.remove_current_callback()
obs.timer_add(timer_callback, reload_interval_minutes * 60 * 1000)
end

function script_load(settings)
obs.timer_add(timer_callback, reload_interval_minutes * 60 * 1000)
end

function script_unload()
-- stop timers when script is unloaded
obs.timer_remove(timer_callback)
end
