

gridUtility = require "gridUtility"

local level = {}

-- LOAD
function level.load(states, levelNumber)
  
  
  screenState = states
  -- TODO: take information from a file or something
  if levelNumber == 1 then
    
    -- get image resources.
  bgImage = love.graphics.newImage("assets/grass.png")
  block = love.graphics.newImage("assets/tile.png")
  playerImage = love.graphics.newImage("assets/man.png")
  goal = love.graphics.newImage("assets/goal.png")
  wall = love.graphics.newImage("assets/wall.png")
  -- add them to a collection (table, I think they're called.)
  assets = {bgImage=bgImage, block=block, playerImage=playerImage, goal=goal, wall=wall}
  
  -- tile size dictated by the background image.
  -- this adds a dependency that all images are the same dimensions
  -- as the bgImage to fit correctly in the tiles of the grid.
  tile_width = bgImage:getWidth()
  tile_height = bgImage:getHeight()
  
  grid = {}
  
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
    player.x_grid = 4
    player.y_grid = 2
    
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
    board.grid[4][4] = 2
    board.grid[5][5] = 1
    
    
    -- set the goal points.
    -- goals are on a separate grid but will still have a unique identifier
    -- for when it is turned into a collection.
    board.goalGrid[2][1] = 3    
    board.goalGrid[2][2] = 3
    board.goalGrid[2][3] = 3
  end

end

-- UPDATE
function level.update(gc, dt)
  
  if isWinner() then
    gc.screen = screenState.WINNER_SCREEN
  end
end

function isWinner()
  
  winner = true
  for i=0,board.size_x do
    for j=0,board.size_y do
      if board.goalGrid[i][j] == 3 and board.grid[i][j] ~= 2 then
        winner = false
        return winner
      end
    end 
  end
  return winner
  
end


-- DRAW
function level.draw()
  
  drawBackgroundImages(board)
  drawBoard(board)
  drawGoals(board)
  drawPlayer(player)

end

-- KEYPRESS
function level.keyPressed(gc, key)
  
  if key == "up" then
    if (player.y_grid - 1) >= 0 then 
       movePlayer(player.x_grid, player.y_grid - 1)
    end
  elseif key == "down" then
    if (player.y_grid + 1) < board.size_y then
       movePlayer(player.x_grid, player.y_grid + 1)
    end
  end
  if key == "left" then
    if (player.x_grid - 1) >= 0 then
       movePlayer(player.x_grid - 1, player.y_grid)
    end 
  elseif key == "right" then
    if (player.x_grid + 1) < board.size_x then
       movePlayer(player.x_grid + 1, player.y_grid)
    end
  end

end



-- OTHER METHODS (private) ((Can LUA have private methods?))


-- Moves the player if that is possible.
function movePlayer(newX, newY)

  xdiff = newX - player.x_grid
  ydiff = newY - player.y_grid
  
  if board.grid[newX][newY] == 1 then 
    return false
  end
  
  if (xdiff == 1 or xdiff == -1) and ydiff == 0 then
    if (board.grid[newX][newY] ~= 2) then -- 2 is a box?
      board.grid[x][y] = 0
      board.grid[newX][newY] = 0
      player.x_grid = newX
      player.y_grid = newY
    else -- is a block
      if moveBox(newX, newY, xdiff, ydiff) then
        board.grid[player.x_grid][player.y_grid] = 0
        board.grid[newX][newY] = 0
        player.x_grid = newX
        player.y_grid = newY
      end
    end
  elseif (ydiff == 1 or ydiff == -1) and xdiff == 0 then
    if (board.grid[newX][newY] ~= 2) then
      board.grid[player.x_grid][player.y_grid] = 0
      board.grid[newX][newY] = 0
      player.x_grid = newX
      player.y_grid = newY
    else
      if moveBox(newX, newY, xdiff, ydiff) then
        board.grid[player.x_grid][player.y_grid] = 0
        board.grid[newX][newY] = 0
        player.x_grid = newX
        player.y_grid = newY
      end
    end
  end

end


function moveBox(x, y, xdiff, ydiff)
  
  -- assert that x, y is a block.
  if board.grid[x][y] ~= 2 then return false end
  -- if position to move the block into is a wall, don't do it.
  if board.grid[x+xdiff][y+ydiff] == 1 then return false end
  

  if (xdiff == 1  or xdiff == -1) and ydiff == 0 then
    local newX = x + xdiff
    if (newX >= 0 and newX < board.size_x) and board.grid[newX][y] ~= 2 then
      board.grid[x][y] = 0
      board.grid[newX][y] = 2
      return true
    else
      return false
    end
  elseif (ydiff == 1 or ydiff == -1) and xdiff == 0 then
    local newY = y + ydiff
    if (newY >= 0 and newY < board.size_y) and board.grid[x][newY] ~= 2 then
      board.grid[x][y] = 0 -- empty
      board.grid[x][newY] = 2 -- Box
      return true
    else
      return false
    end
  else
    return false
  end
  return false

end

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
        love.graphics.draw(board.assets.wall, i*board.tile_width, j*board.tile_height)
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
  love.graphics.draw(player.playerImage, player.x_grid*board.tile_width, player.y_grid*board.tile_height)
end


return level

