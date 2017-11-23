gridSizeX = 40
gridSizeY = 30
cellSize = 20

function love.load()
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
    if button == 2 then
        toggleMine(x, y)
    end
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

            if x == selectedX and y == selectedY then
                if love.mouse.isDown(1) then
                    image = images.uncovered
                else
                    image = images.coveredHighlighted
                end
            else
                image = images.covered
            end
            
            drawCell(image, x, y)

            local surroundingMineCount = 0

            for dx = -1, 1 do
                for dy = -1, 1 do
                    if not (dx == 0 and dy == 0) and
                        grid[x + dx] and grid[x + dx][y + dy] and
                        grid[x + dx][y + dy].mine then
                        surroundingMineCount = surroundingMineCount + 1
                    end
                end
            end
            
            if grid[x][y].mine then
                drawCell(images.mine, x, y)
            elseif surroundingMineCount > 0 then
                drawCell(images[surroundingMineCount], x, y)
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
    for x = 1, gridSizeX do
        grid[x] = {}
        for y = 1, gridSizeY do
            grid[x][y] = {
                mine = false
            }
        end
    end
end

function toggleMine(x, y)
    grid[selectedX][selectedY].mine = not grid[selectedX][selectedY].mine
end