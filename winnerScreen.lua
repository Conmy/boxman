


local winnerScreen = {}


function winnerScreen.load(states)
	
	screenState = states
	
	winnerImage = love.graphics.newImage("assets/winner.png")

end


function winnerScreen.update(gc, dt)
	-- Nah... Won't do anything here yet. (lazy and no need.)

end

function winnerScreen.draw()
	love.graphics.draw(winnerImage, 0, 0)
end


function winnerScreen.keyPressed(gc, key)
	if key == "return" then
		gc.screen = screenState.LEVEL_SCREEN
		gc.levelNumber = gc.levelNumber + 1
		level.initLevel(gc)
	end
end



return winnerScreen
