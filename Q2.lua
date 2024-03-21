-- Q2 - Fix or improve the implementation of the below method
function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local resultId = db.storeQuery("SELECT `name` FROM `guilds` WHERE `max_members` < " .. memberCount)
	if resultId then
		repeat
            -- Get the guild's name from the query and print it
            print(result.getString("name"))
		until not result.next(resultId)

        -- Release the query
		result.free(resultId)
	end
end