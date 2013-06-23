
-- #######################################

gridUtility = require "gridUtility"
level = require "level"

function love.load()
    
  printDebug = true

  

  level.load(1)

end


function love.update(dt)
  
  
end


function love.draw()
  
  level.draw()
  
  -- might use this to get some info from the game while playing.
  -- until I learn to use the debugger or for analysis on screen.
  if printDebug == true then printDebugInfo() end
end

function love.keypressed(key)
  level.keyPressed(key)
end


-- REST OF CODE
-- ################################################################################################
-- DRAW METHODS
-- ################################################################################################


function printDebugInfo()
  
  love.graphics.print( "x_pos: " .. player.x_pos .. " y_pos: " .. player.y_pos, 0, 0 )
  love.graphics.print( "x_grid: " .. player.x_grid .. " y_grid: " .. player.y_grid, 0, 10 )
  love.graphics.print( "moving = " .. booleanToString(player.moving), 0, 20)
  
end

function booleanToString(bool)
  
  if bool == false then
    return "False"
  else
    return "True"
  end

end




