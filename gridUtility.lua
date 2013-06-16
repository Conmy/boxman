-- Declare.
local gridUtility = {}

-- Methods go here.

function gridUtility.getGrid(x, y)
  local localgrid = {}
  for i=0,x do
    localgrid[i] = {}
    for j=0,y do
      localgrid[i][j] = 0 
    end 
  end
  return localgrid
end

return gridUtility
