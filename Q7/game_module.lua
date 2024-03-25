m_ModuleFunctions = {}
m_ModuleCache = {}

m_ModuleFunctions.step = 6

function onLoad()
    connect(g_game, {
        onGameStart = m_ModuleFunctions.onGameStart,
        onGameEnd = m_ModuleFunctions.onGameEnd
    })
end

function onUnload()
    disconnect(g_game, {
        onGameStart = m_ModuleFunctions.onGameStart,
        onGameEnd = m_ModuleFunctions.onGameEnd
    })
end

m_ModuleFunctions.executeEvent = function()
    local offsetX = m_ModuleCache.button:getMarginLeft()
    if offsetX <= m_ModuleFunctions.step then
        m_ModuleFunctions.jump()
    else
        m_ModuleCache.button:setMarginLeft(offsetX - m_ModuleFunctions.step)
    end
end

m_ModuleFunctions.jump = function()
    m_ModuleCache.button:setMarginLeft(m_ModuleCache.window:getWidth() - m_ModuleCache.button:getWidth())
    
    local offsetY = m_ModuleCache.button:getMarginTop()
    m_ModuleCache.button:setMarginTop(math.random(20, m_ModuleCache.window:getHeight() - m_ModuleCache.button:getHeight() - 8))
end

m_ModuleFunctions.onGameStart = function()
    m_ModuleCache.window = g_ui.displayUI("game_module")
    m_ModuleCache.button = m_ModuleCache.window:getChildById("button")
    m_ModuleCache.event = cycleEvent(m_ModuleFunctions.executeEvent, 50)
end

m_ModuleFunctions.onGameEnd = function()
    if m_ModuleCache.window then
        m_ModuleCache.event:cancel()
        m_ModuleCache.window:destroy()
        m_ModuleCache = {}
    end
end