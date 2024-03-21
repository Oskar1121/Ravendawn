-- Q3 - Fix or improve the name and the implementation of the below method
function doRemovePartyMember(playerId, memberName)
    local player = Player(playerId)
    if not player then
        -- Player doesn't exist
        return false
    end

    local party = player:getParty()
    if not party then
        -- Player is not in the party
        return false
    end

    for _, member in pairs(party:getMembers()) do 
        if member:getName() == memberName then
            -- We have found the player and we don't expect to find another player with this name
            party:removeMember(member)
            return true
        end
    end

    return false
end