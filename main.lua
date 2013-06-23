gridUtility = require "gridUtility"
level = require "level"
gameController = require "gameController"
-- #######################################

screenState = { 
  START_SCREEN = {}, 
  WINNER_SCREEN = {}, 
  RETRY_SCREEN = {}, 
  PAUSE_SCREEN = {}, 
  LEVEL_SCREEN = {}
}

function love.load()    
  printDebug = true

  gameController.screen = screenState.LEVEL_SCREEN
  level.load(screenState, 1)

end


function love.update(dt)
  
--  if gameController.screen == screenState.START_SCREEN then
--  
--  elseif gameController.screen == screenState.WINNER_SCREEN then
--  
--  elseif gameController.screen == screenState.RETRY_SCREEN then
--  
--  elseif gameController.screen == screenState.PAUSE_SCREEN then
--  
--  elseif gameController.screen == screenState.LEVEL_SCREEN then
    level.update(gameController, dt)
--  end
  
  
end


function love.draw()
  
  
  if gameController.screen == screenState.WINNER_SCREEN then
    love.graphics.print( "WINNER", 100, 100 ) 
  elseif gameController.screen == screenState.LEVEL_SCREEN then
    level.draw()
  end
  
  -- might use this to get some info from the game while playing.
  -- until I learn to use the debugger or for analysis on screen.
  if printDebug == true then 
    printDebugInfo() 
  end
end

function love.keypressed(key)

  if gameController.screen == screenState.LEVEL_SCREEN then
    level.keyPressed(gameController, key)
  end
end


-- REST OF CODE
-- ################################################################################################
-- DRAW METHODS
-- ################################################################################################


function printDebugInfo()
  
  love.graphics.print( "x_pos: " .. player.x_pos .. " y_pos: " .. player.y_pos, 0, 0 )
  love.graphics.print( "x_grid: " .. player.x_grid .. " y_grid: " .. player.y_grid, 0, 10 )
  love.graphics.print( "moving = " .. booleanToString(player.moving), 0, 20)
  
  if gameController.screen == screenState.LEVEL_SCREEN then
    love.graphics.print( "level screenState: LEVEL" , 0, 30 )
  elseif gameController.screen == screenState.WINNER_SCREEN then
    love.graphics.print( "level screenState: WINNER", 0, 30 )
  end
  
  
end

function booleanToString(bool)
  
  if bool == false then
    return "False"
  else
    return "True"
  end

end




