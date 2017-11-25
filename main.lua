gridSizeX = 40
gridSizeY = 30
cellSize = 20
numberOfMines = 120

function love.load()
    gameOver = false
    loadImages()
    placeMines()
end

function love.update(dt)
    getMousePos()
end

function love.draw()
    drawTIles(gridSizeX, gridSizeY)
    drawMousePos()
end

function love.mousereleased(mouseX, mouseY, button)
    if not gameOver then
        if button == 1 and grid[selectedX][selectedY].state ~= 'flag' then
            if grid[selectedX][selectedY].mine then
                grid[selectedX][selectedY].state = 'uncovered'
                gameOver = true
            else
                local stack = {
                    {
                        x = selectedX,
                        y = selectedY
                    }
                }
        
                while #stack > 0 do
                    local current = table.remove(stack)
                    local x = current.x
                    local y = current.y
        
                    grid[x][y].state = 'uncovered'
        
                    if getSurroundingMineCount(x, y) == 0 then
                        for dx = -1, 1 do
                            for dy = -1, 1 do
                                if not (x == 0 and y == 0)
                                    and grid[x + dx]
                                    and grid[x + dx][y + dy]
                                    and (
                                        grid[x + dx][y + dy].state == 'covered' or
                                        grid[x + dx][y + dy].state == 'question'
                                    )
                                then
                                    table.insert(stack, {
                                        x = x + dx,
                                        y = y + dy
                                    })
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if button == 2 then
        if grid[selectedX][selectedY].state == 'covered' then
            grid[selectedX][selectedY].state = 'flag'
        elseif grid[selectedX][selectedY].state == 'flag' then
            grid[selectedX][selectedY].state = 'question'
        elseif grid[selectedX][selectedY].state == 'question' then
            grid[selectedX][selectedY].state = 'covered'
        end
    end
end

function love.keypressed()
    -- love.load()
end

function loadImages()
    images = {}
    for imageIndex, image in ipairs({
        1, 2, 3, 4, 5, 6, 7, 8, 'uncovered', 'coveredHighlighted', 'covered', 'mine', 'flag', 'question'
    }) do
        images[image] = love.graphics.newImage('images/' .. image .. '.png')
    end
end

function drawTIles(gridX, gridY)
    for x = 1, gridX do
        for y = 1, gridY do
            local image

            if grid[x][y].state == 'uncovered' then
                image = images.uncovered
            else
                if x == selectedX and y == selectedY then
                    if love.mouse.isDown(1) then
                        if grid[x][y].state == 'flag' then
                            image = images.covered
                        else
                            image = images.uncovered
                        end
                    else
                        image = images.coveredHighlighted
                    end
                else
                    image = images.covered
                end
            end

            
            drawCell(image, x, y)
            
            surroundingMineCount = getSurroundingMineCount(x, y)
            
            if grid[x][y].mine then
                drawCell(images.mine, x, y)
            elseif surroundingMineCount > 0 then
                drawCell(images[surroundingMineCount], x, y)
            end

            if grid[x][y].state == 'flag' then
                drawCell(images.flag, x, y)
            elseif grid[x][y].state == 'question' then
                drawCell(images.question, x, y)
            end
            
        end
    end
end

function getMousePos()
    selectedX = math.floor(love.mouse.getX() / cellSize) + 1
    selectedY = math.floor(love.mouse.getY() / cellSize) + 1

    if selectedX > gridSizeX then
        selectedX = gridSizeX
    end

    if selectedY > gridSizeY then
        selectedY = gridSizeY
    end
end

function drawMousePos()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Selected x: " .. selectedX .. ", Selected y: " .. selectedY)
    love.graphics.setColor(255, 255, 255)
end

function drawCell(image, x, y)
    love.graphics.draw(image, (x - 1) * cellSize, (y - 1) * cellSize)    
end

function placeMines()
    grid = {}
    local possibleMineLocations = {}

    for x = 1, gridSizeX do
        grid[x] = {}
        for y = 1, gridSizeY do
            table.insert(possibleMineLocations, { x = x, y = y })

            grid[x][y] = {
                mine = false,
                state = 'covered'
            }
        end
    end

    for mineIndex = 1, numberOfMines do
        local position = table.remove(possibleMineLocations, love.math.random(#possibleMineLocations))
        grid[position.x][position.y].mine = true
    end

end

function toggleMine(x, y)
    grid[selectedX][selectedY].mine = not grid[selectedX][selectedY].mine
end

function getSurroundingMineCount(x, y)
    local surroundingMineCount = 0
    
    for dx = -1, 1 do
        for dy = -1, 1 do
            if not (dx == 0 and dy == 0) and
                grid[x + dx] and 
                grid[x + dx][y + dy] and
                grid[x + dx][y + dy].mine 
            then
                surroundingMineCount = surroundingMineCount + 1
            end
        end
    end

    return surroundingMineCount
end