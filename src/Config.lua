-- SHARKPROJECT | Config Module
if _G.SharkProject_Config then return end

_G.SharkProject_Config = {
    -- Combat
    Aimbot = {
        Enabled = false,
        FOV = 150,
        Smoothness = 0.2,
        TeamCheck = true,
        WallCheck = true,
        TargetPart = "Head"
    },
    -- Visuals
    ESP = {
        Enabled = false,
        Box = true,
        Name = true,
        Health = true,
        Distance = true,
        Chams = true,
        Tracer = true,
        Arrows = true
    },
    -- Movement
    Player = {
        WalkSpeed = 16,
        JumpPower = 50,
        Noclip = false,
        InfJump = false
    },
    -- UI Settings
    UI = {
        Notifications = true,
        AccentColor = Color3.fromRGB(200, 30, 30)
    }
}

print("[SharkProject] Config loaded.")
