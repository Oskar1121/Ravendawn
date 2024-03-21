// Q4 - Assume all method calls work fine. Fix the memory leak issue in below method
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = new Player(nullptr);
        if (!player) {
            // Failed to allocate memory
            return;
        }

        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            // We did not load the player properly, we need to release the memory
            delete player;
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        if (player->isOffline()) {
            // Release the memory
            delete player;
        }

        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);
    if (player->isOffline()) {
        IOLoginData::savePlayer(player);

        // Release the memory
        delete player;
    }
}