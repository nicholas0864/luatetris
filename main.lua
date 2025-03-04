
local Game = require("game")

local game

function love.load()
    love.window.setTitle("Basic Tetris")
    love.window.setMode(300, 600)
    game = Game:new()
    game:start()
end


function love.update(dt)
    game:update(dt)
end

function love.draw()
    game:draw()
end


function love.keypressed(key)
    game:keypressed(key)
end