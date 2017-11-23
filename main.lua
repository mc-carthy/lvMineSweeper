gridSizeX = 40
gridSizeY = 30
cellSize = 20

function love.load()
    loadImages()
end

function love.update(dt)
    getMousePos()
end

function love.draw()
    drawTIles(gridSizeX, gridSizeY)
    drawMousePos()
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
            love.graphics.draw(image, (x - 1) * cellSize, (y - 1) * cellSize)
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