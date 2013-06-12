

gridUtility = require "gridUtility"


-- Called at the start of the application.
-- Initialise resources etc.
function love.load()

  grass = love.graphics.newImage("assets/grass.png")
  block = love.graphics.newImage("assets/tile.png")
  man = love.graphics.newImage("assets/man.png")
  goal = love.graphics.newImage("assets/goal.png")

  tile_width = grass:getWidth()
  tile_height = grass:getHeight()

    -- create the grid for the image layout.
  initialiseLevel(1)
end

-- initialise the level constraints.
function initialiseLevel(levelNumber)
  -- default numbers for parameters.
  levelNumber = levelNumber or 1
  -- create a grid to hold tile values
    -- grid initialised now set up level.
  if levelNumber == 1 then
    initialiseLevel1()
  end
end

function initialiseLevel1()
  grid_size_x = 8
  grid_size_y = 6

  grid = gridUtility.getGrid(grid_size_x, grid_size_y) 
  goalGrid = gridUtility.getGrid(grid_size_x, grid_size_y)
 

  grid[1][1] = 2
  grid[1][3] = 2
  grid[2][2] = 2

  goalGrid[4][4] = 4

  man_x = 3
  man_y = 3
end

-- Main draw method.
function love.draw()
  drawBackTiles()
  drawGoals()
  drawMan()
end

-- Draws the man onto the screen.
function drawMan()
  love.graphics.draw(man, man_x*tile_width, man_y*tile_height)
end

function drawGoals()
  for i=0, grid_size_x do
    for j=0, grid_size_y do
      if goalGrid[i][j] == 4 then
        love.graphics.draw(goal, i*tile_width, j*tile_height)
      end
    end
  end
end

-- Draw the back tiles of the level.
function drawBackTiles()
  for i=0, grid_size_x do
    for j=0, grid_size_y do
      if grid[i][j] == 2 then
        drawBlock(i, j)
      else
        drawGrass(i, j)
      end
    end
  end
end

function love.keypressed(key)

    if key == "up" or key == "down" or key == "left" or key == "right" then
        moveManFromKeyPress(key)
    end
end

function moveManFromKeyPress(key)
  if key == "up" then
    if (man_y - 1) >= 0 then 
       moveMan(man_x, man_y, man_x, man_y - 1)
    end
  elseif key == "down" then
    if (man_y + 1) < grid_size_y then
       moveMan(man_x, man_y, man_x, man_y + 1)
    end
  end
  if key == "left" then
    if (man_x - 1) >= 0 then
       moveMan(man_x, man_y, man_x - 1, man_y)
    end 
  elseif key == "right" then
    if (man_x + 1) < grid_size_x then
       moveMan(man_x, man_y, man_x + 1, man_y)
    end
  end
end

function drawGrass(x, y)
  love.graphics.draw(grass, x*tile_width, y*tile_height)
end

function drawBlock(x, y)
  love.graphics.draw(block, x*tile_width, y*tile_height)
end

function moveMan(x, y, newX, newY)
  xdiff = newX - x
  ydiff = newY - y
  if (xdiff == 1 or xdiff == -1) and ydiff == 0 then
    if (grid[newX][newY] ~= 2) then
      grid[x][y] = 0
      grid[newX][newY] = 0
      man_x = newX
      man_y = newY
    else -- is a block
      if moveBlock(newX, newY, xdiff, ydiff) then
        grid[x][y] = 0
        grid[newX][newY] = 0
        man_x = newX
        man_y = newY
      end
    end
  elseif (ydiff == 1 or ydiff == -1) and xdiff == 0 then
    if (grid[newX][newY] ~= 2) then
      grid[x][y] = 0
      grid[newX][newY] = 0
      man_x = newX
      man_y = newY
    else
      if moveBlock(newX, newY, xdiff, ydiff) then
        grid[x][y] = 0
        grid[newX][newY] = 0
        man_x = newX
        man_y = newY
      end
    end
  end

end

function moveBlock(x, y, xdiff, ydiff)
  
  -- assert that x, y is a block.
  if grid[x][y] ~= 2 then return false end

  if (xdiff == 1  or xdiff == -1) and ydiff == 0 then
    local newX = x + xdiff
    if (newX >= 0 and newX < grid_size_x) and grid[newX][y] ~= 2 then
      grid[x][y] = 0
      grid[newX][y] = 2
      return true
    else
      return false
    end
  elseif (ydiff == 1 or ydiff == -1) and xdiff == 0 then
    local newY = y + ydiff
    if (newY >= 0 and newY < grid_size_y) and grid[x][newY] ~= 2 then
      grid[x][y] = 0
      grid[x][newY] = 2
      return true
    else
      return false
    end
  else
    return false
  end
  return false
end

