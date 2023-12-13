local playerData = {}

CreateThread(function()
    while true do 
        for i=1, #playerData do 
            if playerData[i] then 
                playerData[i]['fs_playtime'] = playerData[i]['fs_playtime'] + 30
            end
        end
        
        Wait(30 * 1000)
    end
end)

AddEventHandler('esx:playerLoaded', function(src)
    local xPlayer = ESX.GetPlayerFromId(src)
    if source == 0 or source == '' then
        MySQL.scalar('SELECT `fs_playtime` FROM `users` WHERE `identifier` = @identifier LIMIT 1', {
            ['identifier'] = xPlayer.identifier
        }, function(result)
            if not playerData[src] then 
                playerData[src] = {}
            end

            playerData[src]['fs_playtime'] = tonumber(result) or 0 
            playerData[src]['actualTime'] = os.time()

            local message = "**Player:** " .. GetPlayerName(src) .. " Has joined and their playtime has been loaded, their playtime is: " ..secconvert(playerData[src]['fs_playtime']) .. "."
            discordLog(message)
        end)
    end
end)

AddEventHandler('esx:playerDropped', function(src, reason)
    local xPlayer = ESX.GetPlayerFromId(src)
    if source == 0 or source == '' then
        if not playerData[src] then return end
        
        MySQL.update('UPDATE `users` SET `fs_playtime` = @playtime WHERE identifier = @identifier', {
            ['playtime'] = playerData[src]['fs_playtime'], ['identifier'] = xPlayer.identifier
        }, function(affectedRows)
        end)
        local message = "**player:** " .. GetPlayerName(src) .. " logged out and their playtime has been saved, Current playtime: " ..secconvert(playerData[src]['fs_playtime']) .. "."
        discordLog(message)
    end
end)

RegisterCommand(FS.command, function(source, args, rawCommand)
    TriggerClientEvent('chat:addMessage', source, { args = { 'Your total playtime is: ' ..secconvert(playerData[source]['fs_playtime']) .. ' !' }})
end)

function discordLog(message)
    PerformHttpRequest(FS.webhook, function(err, text, headers) end, 'POST', json.encode({username = 'fs_playtime', embeds = {{["description"] = "".. message .."",["footer"] = {["text"] = "Fusion Scripts - https://discord.gg/EykRUujAmr",["icon_url"] = "https://www.jokedevil.com/img/logo.png",},}}, avatar_url = "https://media.discordapp.net/attachments/1168953209033855108/1168970881528254575/kk.png?ex=656628f8&is=6553b3f8&hm=a693b4acc03c6bd84b7de1967f361c2b8803c46cffe4c3277257dfa688346083&=&width=211&height=203"}), { ['Content-Type'] = 'application/json' })
end

secconvert = function(seconds)
    if not seconds then return end

    local seconds = tonumber(seconds)
    if seconds <= 0 then return '0 days, 0 hours, 0 minutes'  end
    days = string.format('%02.f', math.floor(seconds / (3600*24)));
    hours = string.format('%02.f', math.floor(seconds / 3600));
    mins = string.format('%02.f', math.floor(seconds / 60 - (hours * 60)));
    secs = string.format('%02.f', math.floor(seconds - hours * 3600 - mins * 60));
    return days .. ' days, ' .. hours .. ' hours, ' .. mins .. ' minutes'
end