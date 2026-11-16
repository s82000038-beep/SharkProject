-- SHARKPROJECT | Main Loader
local GITHUB_USER = "s82000038-beep"
local REPO_NAME = "SharkProject"
local BRANCH = "main"
-- Исправленная ссылка (добавлен параметр %s для BRANCH)
local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/src/", GITHUB_USER, REPO_NAME, BRANCH)

local function loadModule(moduleName)
    local url = BASE_URL .. moduleName .. ".lua"
    print("[SharkProject] Загрузка: " .. url)
    
    local success, code = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success and code and code ~= "" and not code:find("404: Not Found") then
        local func, err = loadstring(code)
        if func then
            func()
            print("[SharkProject] Успешно: " .. moduleName)
        else
            warn("[SharkProject] Ошибка синтаксиса в " .. moduleName .. ": " .. tostring(err))
        end
    else
        warn("[SharkProject] Ошибка загрузки " .. moduleName .. ". Код ответа: " .. tostring(code))
    end
end

local function init()
    print("[SharkProject] Инициализация...")
    loadModule("Config")
    loadModule("Core")
    loadModule("UI")
    print("[SharkProject] Готово.")
end

init()
