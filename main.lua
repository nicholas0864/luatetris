-- Main module
-- This is the main entry point for the Tetris game using the Love2D framework.

local Game = require("game")

local game

-- Called once at the beginning of the game.
-- Sets up the window title and size, and initializes the game.
function love.load()
    love.window.setTitle("Basic Tetris")
    love.window.setMode(300, 600)
    game = Game:new()
    game:start()
end

-- Called continuously to update the game state.
-- @param dt The time elapsed since the last update.
function love.update(dt)
    game:update(dt)
end

-- Called continuously to draw the game.
function love.draw()
    game:draw()
end

-- Called when a key is pressed.
-- @param key The key that was pressed.
function love.keypressed(key)
    game:keypressed(key)
end