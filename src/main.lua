-- SHARKPROJECT | Main Loader
-- Замени 'ТВОЙ_НИКНЕЙМ' на свой GitHub Username
local GITHUB_USER = "s82000038-beep"
local REPO_NAME = "sharkproject"
local BRANCH = "main"
local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/src/", GITHUB_USER, REPO_NAME, BRANCH)

local function loadModule(moduleName)
    local url = BASE_URL .. moduleName .. ".lua"
    local success, code = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and code and code ~= "" and not code:find("404: Not Found") then
        local func, err = loadstring(code)
        if func then
            func()
            print("[SharkProject] Модуль загружен: " .. moduleName)
        else
            warn("[SharkProject] Ошибка компиляции " .. moduleName .. ": " .. tostring(err))
        end
    else
        warn("[SharkProject] Не удалось загрузить " .. moduleName .. ". Проверь GitHub.")
    end
end

-- Инициализация
local function init()
    print("[SharkProject] Запуск...")
    loadModule("Config")
    loadModule("Core")
    loadModule("UI")
    print("[SharkProject] Успешно запущен.")
end

init()
