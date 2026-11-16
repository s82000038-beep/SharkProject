-- SHARKPROJECT | Core Module
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LP = Players.LocalPlayer

local Config = _G.SharkProject_Config
if not Config then return end

_G.SharkProject_Core = {}
local Core = _G.SharkProject_Core

-- Утилиты
function Core.IsEnemy(plr)
    if plr == LP then return false end
    if Config.Aimbot.TeamCheck and LP.Team and plr.Team then
        return LP.Team ~= plr.Team
    end
    return true
end

function Core.IsVisible(part)
    if not part then return false end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LP.Character, part.Parent}
    params.FilterType = Enum.RaycastFilterType.Exclude
    return Workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, params) == nil
end

-- ============ AIMBOT ============
local currentTarget = nil
RunService:BindToRenderStep("SharkAimbot", Enum.RenderPriority.Camera.Value + 1, function()
    if not Config.Aimbot.Enabled then return end
    local closest, minDist = nil, Config.Aimbot.FOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and Core.IsEnemy(plr) then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local target = plr.Character:FindFirstChild(Config.Aimbot.TargetPart) or hrp
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            
            if hrp and target and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(target.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < minDist then
                        if Config.Aimbot.WallCheck and not Core.IsVisible(target) then continue end
                        minDist = dist
                        closest = target
                    end
                end
            end
        end
    end

    if closest then
        local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, closest.Position)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 - Config.Aimbot.Smoothness)
    end
end)

-- ============ ESP (Оптимизированный) ============
local espCache = {}
local function clearESP()
    for _, obj in pairs(espCache) do
        if obj.highlight then obj.highlight:Destroy() end
        if obj.billboard then obj.billboard:Destroy() end
        if obj.box then obj.box:Remove() end
    end
    espCache = {}
end

RunService.RenderStepped:Connect(function()
    if not Config.ESP.Enabled then 
        if next(espCache) then clearESP() end
        return 
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character and Core.IsEnemy(plr) then
            local char = plr.Character
            local head = char:FindFirstChild("Head")
            local hum = char:FindFirstChildOfClass("Humanoid")
            
            if head and hum and hum.Health > 0 then
                if not espCache[plr] then
                    -- Создание элементов
                    local hl = Instance.new("Highlight")
                    hl.Adornee = char
                    hl.FillColor = Config.UI.AccentColor
                    hl.OutlineColor = Color3.new(1,1,1)
                    hl.Parent = char

                    local bb = Instance.new("BillboardGui")
                    bb.Adornee = head
                    bb.Size = UDim2.new(0, 100, 0, 50)
                    bb.StudsOffset = Vector3.new(0, 2, 0)
                    bb.AlwaysOnTop = true
                    bb.Parent = head

                    local nameLbl = Instance.new("TextLabel")
                    nameLbl.Size = UDim2.new(1,0,0,15)
                    nameLbl.BackgroundTransparency = 1
                    nameLbl.TextColor3 = Color3.new(1,1,1)
                    nameLbl.Font = Enum.Font.RobotoMono
                    nameLbl.TextSize = 11
                    nameLbl.Parent = bb

                    espCache[plr] = { highlight = hl, billboard = bb, name = nameLbl }
                end

                local o = espCache[plr]
                local dist = math.floor((Camera.CFrame.Position - char.HumanoidRootPart.Position).Magnitude)
                
                o.highlight.Enabled = Config.ESP.Chams
                o.name.Visible = Config.ESP.Name
                o.name.Text = plr.Name .. " [" .. dist .. "m]"
            end
        else
            if espCache[plr] then
                if espCache[plr].highlight then espCache[plr].highlight:Destroy() end
                if espCache[plr].billboard then espCache[plr].billboard:Destroy() end
                espCache[plr] = nil
            end
        end
    end
end)

print("[SharkProject] Core loaded.")
