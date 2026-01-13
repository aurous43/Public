local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")

-- ================= CONFIGURATION ================= --
local Config = {
    -- DIRECT link to the .mp3 file
    Url = "https://github.com/aurous43/Public/raw/refs/heads/main/So,%20DON'T%20BLINK.mp3", 
    
    -- The name to save the file as in your workspace folder
    FileName = "So, DON'T BLINK.mp3",

    -- Delay before playing the song
    DelayBeforePlay = 0, -- Set to 0 for instant sync since we are preloading

    -- Time to skip to (in seconds) when the LMS ends
    SkipToTime = 248,

    -- Volume of the custom song
    Volume = 1,
}
-- ================================================= --

-- 1. Exploit Support Check & File Downloading
local function getAsset()
    if not isfile or not writefile or not getcustomasset or not game.HttpGet then
        warn("Your executor does not support required functions.")
        return nil
    end

    -- Download if it doesn't exist
    if not isfile(Config.FileName) then
        warn("Downloading 'So, DON'T BLINK'...")
        local content = game:HttpGet(Config.Url)
        writefile(Config.FileName, content)
        print("'So, DON'T BLINK' Download complete.")
    end

    return getcustomasset(Config.FileName)
end

local customAssetId = getAsset()
if not customAssetId then return end

-- 2. Create the Sound Instance
local MyCustomSound = Instance.new("Sound")
MyCustomSound.Name = "So, DON'T BLINK"
MyCustomSound.SoundId = customAssetId
MyCustomSound.Volume = Config.Volume
MyCustomSound.Looped = false 
MyCustomSound.Parent = SoundService

-- 3. PRELOAD AUDIO
warn("[Script] Preloading 'So, DON'T BLINK'...")
local start = tick()
ContentProvider:PreloadAsync({MyCustomSound})
warn("'Preloaded So, DON'T BLINK'! Took " .. math.round((tick() - start) * 1000) .. "ms")

-- 4. Locate Game Objects
local TargetSound = ReplicatedStorage:WaitForChild("ClientAssets")
    :WaitForChild("Sounds")
    :WaitForChild("mus")
    :WaitForChild("Game")
    :WaitForChild("Round")
    :WaitForChild("SoloTheme")
    :WaitForChild("SonicSolo") -- change depending on the character, for example TailsSolo, KnucklesSolo, etc.

local GameState = Workspace:WaitForChild("GameProperties")
    :WaitForChild("State")

-- 5. Play Logic
local function onTargetPlayChanged()
    if TargetSound.Playing then
        -- Mute the original immediately
        TargetSound.Volume = 0
        
        -- Optional delay
        if Config.DelayBeforePlay > 0 then
            task.wait(Config.DelayBeforePlay)
        end

        -- Verify playing state and Play Custom
        if TargetSound.Playing then
            MyCustomSound:Play()
        end
    else
        MyCustomSound:Stop()
    end
end

-- 6. Lms End/"RE" State Logic
GameState:GetPropertyChangedSignal("Value"):Connect(function()
    if GameState.Value == "RE" then
        if MyCustomSound.IsPlaying then
            -- Set the time position instantly
            MyCustomSound.TimePosition = Config.SkipToTime
        end
    end
end)

-- 8. Initialize Connections
TargetSound:GetPropertyChangedSignal("Playing"):Connect(onTargetPlayChanged)

-- Final check in case song started while we were preloading
if TargetSound.Playing then
    onTargetPlayChanged()
end
