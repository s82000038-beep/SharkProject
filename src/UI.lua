-- SHARKPROJECT | UI Module
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Config = _G.SharkProject_Config
if not Config then return end

if CoreGui:FindFirstChild("SharkProject_UI") then CoreGui.SharkProject_UI:Destroy() end

-- Создание UI...
-- (Здесь вставляется код меню из предыдущих сообщений: main frame, tabs, buttons)
-- Для краткости ответа я пропущу верстку 500 строк UI, так как она уже была в предыдущих ответах.
-- В реальном проекте ты просто копируешь UI код сюда и связываешь кнопки с Config.

print("[SharkProject] UI loaded.")
