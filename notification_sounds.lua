local obs = obslua
local ffi = require("ffi")
local winmm = ffi.load("Winmm")

local AUDIO_REPLAY     = script_path() .. "replay_buffer_save_sound.wav"
local AUDIO_SCREENSHOT = script_path() .. "screenshot_capture.wav"
local AUDIO_REC_START  = script_path() .. "video_capture_start.wav"
local AUDIO_REC_STOP   = script_path() .. "video_capture_stop.wav"

-- FFI DEFINITION
ffi.cdef[[
    bool PlaySound(const char *pszSound, void *hmod, uint32_t fdwSound);
]]

-- CONSTANTS
-- 0x00020000 = SND_FILENAME (The pszSound parameter is a filename)
-- 0x00000001 = SND_ASYNC    (The sound is played asynchronously; script doesn't wait)
-- 0x00000010 = SND_NODEFAULT(No default sound event is used if the file isn't found)
local FLAGS = 0x00020011 

function playsound(filepath)
    winmm.PlaySound(filepath, nil, FLAGS)
end

function on_event(event)
    if event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_SAVED then
        playsound(AUDIO_REPLAY)
    elseif event == obs.OBS_FRONTEND_EVENT_SCREENSHOT_TAKEN then
        playsound(AUDIO_SCREENSHOT)
    elseif event == obs.OBS_FRONTEND_EVENT_RECORDING_STARTED then
        playsound(AUDIO_REC_START)
    elseif event == obs.OBS_FRONTEND_EVENT_RECORDING_STOPPED then
        playsound(AUDIO_REC_STOP)
    end
end

function script_load(settings)
    obs.obs_frontend_add_event_callback(on_event)
end