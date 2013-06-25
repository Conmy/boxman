


local winnerScreen = {}


function winnerScreen.load(states)
	
	screenState = states
	
	winnerImage = love.grapics.getImage("assets/winner.png")

end


function winnerScreen.update(gc, dt)
	-- Nah... Won't do anything here yet. (lazy and no need.)

end

function winnerScreen.draw()
	love.graphics.draw(0, 0, winnerImage)
end


function winnerScreen.keyPressed(gc, key)
	if key == "enter" then
		gc.screen = screenState.LEVEL_SCREEN
		gc.levelNumber = gc.levelNumber + 1
	end
end



return winnerScreen
