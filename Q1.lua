-- Q1 - Fix or improve the implementation of the below methods
local function releaseStorage(player)
    if player:getStorageValue(1000) == 1 then
        player:setStorageValue(1000, -1)
    end
end

function onLogout(player, delay)
    if delay and delay > 0 then
        -- Store player's id
        local playerId = player:getId()
        addEvent(function()
            -- Get the Player from the stored player's id
            local player = Player(playerId)
            if player then
                -- If the player exists, release the storage
                releaseStorage(player)
            end
        end, delay)
    else
        -- Release the storage with no delay
        releaseStorage(player)
    end

    return true
end