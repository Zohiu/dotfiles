-- Lua script
-- Made for OBS Studio
-- Made by: @CoccodrillooXDS
-- MIT License

-- Import OBS libraries and create global variables
obs = obslua
script_path = ""
version = "2.0.0"

-- Function to send a notification to the desktop
-- OS: Windows, macOS, Linux
-- Windows: Requires BurntToast module for PowerShell (gets installed during the script_load phase)
-- macOS: Requires a modern version of macOS
-- Linux: Requires notify-send
function send_notification(title, message)
    os.execute('notify-send "' .. title .. '" "' .. message .. '"')
    os.execute('aplay /home/zohiu/config/configs/obs-studio/OBS-Notifications-2.0.0/savereplay.wav')
end

-- Function to handle OBS events
-- OBS_FRONTEND_EVENT_REPLAY_BUFFER_SAVED: When the replay buffer saves a replay
-- OBS_FRONTEND_EVENT_STREAMING_STARTED: When the stream starts
-- OBS_FRONTEND_EVENT_STREAMING_STOPPED: When the stream stops
-- OBS_FRONTEND_EVENT_RECORDING_STARTED: When the recording starts
-- OBS_FRONTEND_EVENT_RECORDING_STOPPED: When the recording stops
function on_event(event)
    if event == obs.OBS_FRONTEND_EVENT_REPLAY_BUFFER_SAVED then
        print("Replay Saved")
        send_notification('Instant Replay', 'Saved replay!')
    end
    if event == obs.OBS_FRONTEND_EVENT_STREAMING_STARTED then
        print("Streaming Started")
        send_notification('Streaming', 'Stream started!')
    end
    if event == obs.OBS_FRONTEND_EVENT_STREAMING_STOPPED then
        print("Streaming Stopped")
        send_notification('Streaming', 'Stream stopped!')
    end
    if event == obs.OBS_FRONTEND_EVENT_RECORDING_STARTED then
        print("Recording Started")
        send_notification('Recording', 'Recording started!')
    end
    if event == obs.OBS_FRONTEND_EVENT_RECORDING_STOPPED then
        print("Recording Stopped")
        send_notification('Recording', 'Recording stopped!')
    end
end

-- OBS function
function script_properties()
    local props = obs.obs_properties_create()
    return props
end

-- Script description for the OBS Scripts dialog
function script_description()
    return "Sends a notification to the desktop when something happens.\n\nMade by @CoccodrillooXDS\nVersion: " .. version
end

-- OBS function when the script gets loaded
function script_load(settings)
    -- Add the event callback function to the OBS events
    obs.obs_frontend_add_event_callback(on_event)
end
