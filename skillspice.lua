WorldTakeBahan = ""
IdDoorWorldTakebahan = ""
WorldOven = ""
IdDoorWorldOven = ""
WhenToDrophasil = 5 
WorldSave = ""
IdDoorWorldSave = ""
local bot = getBot() 
local arrayItemTotake = {7014,3472,4602,868,962,4572,4570,4566}
bot:setInterval(Action.move,0.025)
bot:setInterval(Action.collect,0.025)
local function warp(world,door)
       bot:warp(world,door)
       sleep(math.random(3,6)*1000)
      while bot.status ~= 1 do
          sleep(50)
       end
end
local function lace(id,x,y)
      bot:place(bot.x+x,bot.y+y,id)
end
local function findItem(item)
     return bot:getInventory():findItem(item)
end
local function punch(x,y)
      bot:hit(bot.x + x, bot.y + y)
end

local function oven(x,y,itemid)
    bot:sendPacket(2,"action|dialog_return\ndialog_name|oven\ntilex|"..(getBot().x+x).."|\ntiley|"..(getBot.y+y).."|\ncookthis|"..itemid.."|\nbuttonClicked|low\n\ndisplay_timer|0")
    sleep(500)
end
local function TakeObject(ids)
	for _, obj in pairs(getObjects()) do
        if obj.id == ids then
            bot:findPath(math.floor(obj.x/32),math.floor(obj.y/32))
            sleep(50)
            bot:collectObject(obj.oid,5)
            if findItem(ids) > 0 then
                break
            end
        end
	end
end
local function TakeItem()
	for i = 1, # arrayItemTotake do
		if findItem(arrayItemTotake[i]) == 0 then
			while bot:getWorld().name ~= WorldTakeBahan:upper() or bot:getWorld():getTile(bot.x, bot.y).fg == 6 do
				warp(WorldTakeBahan, IdDoorWorldTakebahan)
			end
			TakeObject(arrayItemTotake[i])
		end
	end
	while bot:getWorld().name ~= WorldOven:upper() or bot:getWorld():getTile(bot.x, bot.y).fg == 6 do
		warp(WorldOven, IdDoorWorldOven)
	end
end
local function IsItTimeToTake()
    for i = 1, # arrayItemTotake do
		if findItem(arrayItemTotake[i]) == 0 then
			return true
		end
	end
    return false
end
local function DropSave()
    while findItem(6912) > 0 and bot.status ==1   do 
        while bot:getWorld().name ~= WorldSave:upper() and bot.status ==1   or bot:getWorld():getTile(bot.x, bot.y).fg == 6  and bot.status ==1  do
			warp(WorldSave, IdDoorWorldSave)
		end
        while findItem(6912) >0 and bot.status ==1   do 
            bot:drop(6912,findItem(6912))
            sleep(5000)
        end
    end
    while bot:getWorld().name ~= WorldOven:upper() or bot:getWorld():getTile(bot.x, bot.y).fg == 6 do
		warp(WorldOven, IdDoorWorldOven)
	end
end

 function wait_mele()
    getBot().custom_status =  "wait_mele"
         sleep(7000)
     while getBot().malady == 0 do
        --getBot():getConsole():append("`2[ACTION] getBot().malady : 0")
         sleep(27000)
     end
 end
 bot.auto_malady.enabled = true
 local function getProgress()
	return bot:getWorld():getTile(bot.x, bot.y).progress
end
while true do
	while bot.status ~= 1 do
		sleep(50)
	end
	while IsItTimeToTake() and bot.status == 1 do
		TakeItem()
	end
	while IsItTimeToTake() == false and bot.status == 1 do
		while bot:getWorld().name ~= WorldOven:upper() and bot.status == 1 or bot:getWorld():getTile(bot.x, bot.y).fg == 6 and bot.status == 1 do
			warp(WorldOven, IdDoorWorldOven)
		end
		while bot:getWorld():getTile(bot.x, bot.y).fg ~= 4618 and bot.status == 1 do
			for i, tile in pairs(getTiles()) do
				if tile.fg == 4618 then
					bot:findPath(tile.x - 1, tile.y)
					break
				end
			end
		end
		while bot:getWorld():getTile(bot.x, bot.y).fg == 4618 and bot.status == 1 or IsItTimeToTake() == false and bot.status == 1 do
			while getProgress() == 0 do
				oven(1, 0, 7014) -- cosmic
				sleep(500)
			end
			sleep(16200)
			while getProgress() == 1 do
				lace(1, 0, 3472) -- rice
				sleep(500)
			end
			sleep(32800)
			while getProgress() == 2 do
				lace(1, 0, 4602) -- onion
				sleep(500)
			end
			while getProgress() == 3 do
				lace(1, 0, 4568) -- salt
				sleep(500)
			end
			while getProgress() == 4 do
				lace(1, 0, 4572) -- Sugar
				sleep(500)
			end
			while getProgress() == 5 do
				lace(1, 0, 4570) -- ppper
				sleep(500)
			end
			sleep(30000)
			while getProgress() == 6 do
				lace(1, 0, 868) -- milk
				sleep(500)
			end
			sleep(2800)
			while getProgress() == 7 do
				lace(1, 0, 962) -- tomato
				sleep(500)
			end
			sleep(29500)
			while getProgress() == 8 do
				punch(1, 0) -- punch
				sleep(500)
			end
		end
		DropSave()
	end
end
