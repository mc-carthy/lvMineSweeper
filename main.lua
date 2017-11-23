gridSizeX = 40
gridSizeY = 30
cellSize = 20

function love.load()
    loadImages()
end

function love.update(dt)

end

function love.draw()
    drawTIles(gridSizeX, gridSizeY)
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
            love.graphics.draw(images.covered, (x - 1) * cellSize, (y - 1) * cellSize)
        end
    end
end