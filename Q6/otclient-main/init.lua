g_app.setName("Ranger's Arcani");
g_app.setCompactName("RA");
g_app.setOrganizationName("RA");

-- setup logger
g_logger.setLogFile(g_resources.getWorkDir() .. g_app.getCompactName() .. '.log')
g_logger.info(os.date('== application started at %b %d %Y %X'))
g_logger.info("== operating system: " .. g_platform.getOSName())

-- print first terminal message
g_logger.info(g_app.getName() .. ' ' .. g_app.getVersion() .. ' rev ' .. g_app.getBuildRevision() .. ' (' ..
    g_app.getBuildCommit() .. ') built on ' .. g_app.getBuildDate() .. ' for arch ' ..
    g_app.getBuildArch())

-- setup lua debugger
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
  g_logger.debug("Started LUA debugger.")
else
  g_logger.debug("LUA debugger not started (not launched with VSCode local-lua).")
end

g_resources.addSearchPath(g_resources.getWorkDir() .. "data", true)
g_resources.addSearchPath(g_resources.getWorkDir() .. "mods", true)
g_resources.addSearchPath(g_resources.getWorkDir() .. "modules", true)
g_resources.addSearchPath(g_resources.getWorkDir() .. "graphics", true)
g_resources.addSearchPath(g_resources.getWorkDir() .. "sounds", true)
g_resources.addSearchPath(g_resources.getWorkDir() .. "lib", true)

g_resources.addSearchPath(g_resources.getWorkDir() .. "data.dll", true)
g_resources.addSearchPath(g_resources.getWorkDir() .. "mods.dll", true)
g_resources.addSearchPath(g_resources.getWorkDir() .. "modules.dll", true)
g_resources.addSearchPath(g_resources.getWorkDir() .. "graphics.dll", true)
g_resources.addSearchPath(g_resources.getWorkDir() .. "sounds.dll", true)

-- setup directory for saving configurations
g_resources.setupUserWriteDir('config/')

-- search all packages
g_resources.searchAndAddPackages('/', '.otpkg', true)

-- load settings
g_configs.loadSettings("/config.otml")
g_minimap.loadRamm("/RAMinimap.ramm")

g_modules.discoverModules()

-- libraries modules 0-99
g_modules.autoLoadModules(99)
g_modules.ensureModuleLoaded('corelib')
g_modules.ensureModuleLoaded('gamelib')
g_modules.ensureModuleLoaded("startup")

local function loadModules()
    -- client modules 100-499
    g_modules.autoLoadModules(499)
    g_modules.ensureModuleLoaded('client')

    -- game modules 500-999
    g_modules.autoLoadModules(999)
    g_modules.ensureModuleLoaded('game_interface')

    -- mods 1000-9999
    g_modules.autoLoadModules(9999)

    local script = '/' .. g_app.getCompactName() .. 'rc.lua'
    if g_resources.fileExists(script) then
        dofile(script)
    end
end

loadModules()

-- uncomment the line below so that modules are reloaded when modified. (Note: Use only mod dev)
-- g_modules.enableAutoReload()
