
-- #######################################

gridUtility = require "gridUtility"


function love.load()
    
  printDebug = true

  grid = {}
  
  -- get image resources.
  bgImage = love.graphics.newImage("assets/grass.png")
  block = love.graphics.newImage("assets/tile.png")
  playerImage = love.graphics.newImage("assets/man.png")
  goal = love.graphics.newImage("assets/goal.png")
  -- add them to a collection (table, I think they're called.)
  assets = {bgImage=bgImage, block=block, playerImage=playerImage, goal=goal}
  
  -- tile size dictated by the background image.
  -- this adds a dependency that all images are the same dimensions
  -- as the bgImage to fit correctly in the tiles of the grid.
  tile_width = bgImage:getWidth()
  tile_height = bgImage:getHeight()

  board = {
    grid=grid, 
    goalGrid=grid,
    assets=assets, 
    tile_width=tile_width, tile_height=tile_height, 
    size_x, size_y}

  player = {
    playerImage=playerImage,
    x_grid=0, y_grid=0,
    x_pos=0, y_pos=0,
    speed=10, moving=false, allowInput=false} 

  initialiseLevel(board, player, 1)

end


function love.update(dt)
  
  if player.x_pos ~= player.x_grid*board.tile_width and 
    player.y_pos ~= player.y_grid*board.tile_height then

    moving = true
    player.x_pos = 
      math.ceil(player.x_pos + (player.x_grid*board.tile_width - player.x_pos)*dt*player.speed)
    player.y_pos = 
      math.floor(player.y_pos + (player.y_grid*board.tile_height - player.y_pos)*dt*player.speed)

    if player.x_pos == player.x_grid*board.tile_width and 
      player.y_pos == player.y_grid*board.tile_height then
        
      player.moving = false      
    end
  end
  
end


function love.draw()
  drawBackgroundImages(board)
  drawBoard(board)
  drawGoals(board)
  drawPlayer(player)
  
  -- might use this to get some info from the game while playing.
  -- until I learn to use the debugger or for analysis on screen.
  if printDebug == true then printDebugInfo() end
end


-- REST OF CODE

function initialiseLevel(board, player, level)
  
  
  if level == 1 then
    
    -- level constants. (hard coded for now)
    x = 8
    y = 6
    
    -- set up the grid for the board.
    board.grid = gridUtility.getGrid(x, y)
    board.goalGrid = gridUtility.getGrid(x, y)
    -- assets is set from load (for now)
    -- tile height and width would be set along with the image asset.
    board.size_x = x
    board.size_y = y
    
    -- set player objects
    -- player image set from load (for now) 
    
    -- x_grid and y_grid represent the player's position on the grid.
    -- hard coded (for now)
    player.x_grid = 2
    player.y_grid = 4
    
    player.x_pos = 3*board.tile_width
    player.y_pos = 3*board.tile_height
    
    -- set player speed for duration between animations.
    player.speed = 1
    
    -- tells the update method when the player is moving.
    player.moving = false
    
    -- allow the user to make an input on the player.
    player.allowInput = true
    
    -- set up stuff on the grid.
    -- 0 = empty
    -- 1 = wall
    -- 2 = box
    -- 3 = goal
    -- This should probably be set up in a collection.
    board.grid[1][1] = 2
    board.grid[2][2] = 2
    board.grid[5][5] = 2
    
    -- set the goal points.
    -- goals are on a separate grid but will still have a unique identifier
    -- for when it is turned into a collection.
    board.goalGrid[2][1] = 3
    
  end

end

-- ################################################################################################
-- DRAW METHODS
-- ################################################################################################

-- draw a bgImage tile for all tiles on the board.
function drawBackgroundImages(board)
  -- this could end up being unnecessary as more tiles are drawn above it.
  -- when this happens this will need to be made more efficient.
  -- especially with an else statement in the draw board method.
  for i=0, board.size_x do
    for j=0, board.size_y do
      love.graphics.draw(board.assets.bgImage, i*board.tile_width, j*board.tile_width)
    end
  end
end

-- eventually this should be in some sort of Board class/module
function drawBoard(board)
  
  for i=0, board.size_x do
    for j=0, board.size_y do
      if board.grid[i][j] == 0 then
        -- draw the bg image.
        love.graphics.draw(board.assets.bgImage, i*board.tile_width, j*tile_height)
      elseif board.grid[i][j] == 1 then
        -- draw a wall
        --love.graphics.draw(board.assets.block, i*board.tile_width, j*board.tile_height)
      elseif board.grid[i][j] == 2 then
        -- draw a box
        love.graphics.draw(board.assets.block, i*board.tile_width, j*board.tile_height)
      --elseif board.grid[i][j] == 3 then
        -- draw a goal sprite
        -- this is moved
        --love.graphics.draw(board.assets.goal, i*board.tile_width, j*board.tile_height)
      else
        -- draw the bgImage
        love.graphics.draw(board.assets.bgImage, i*board.tile_width, j*board.tile_height)
      end
    end
  end

end

function drawGoals(board)
  
  for i=0, board.size_x do
    for j=0, board.size_y do
      if board.goalGrid[i][j] == 0 then
        -- nothing
        
      elseif board.goalGrid[i][j] == 3 then
        -- draw the goal sprite.
        love.graphics.draw(board.assets.goal, i*board.tile_width, j*board.tile_height)
      else
        -- nothing
      end
    end
  end

end

-- just draws the current position of the player.
function drawPlayer(player)
  love.graphics.draw(player.playerImage, player.x_pos, player.y_pos)
end


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




