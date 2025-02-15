-- Utils module
-- This module contains utility functions used throughout the Tetris game.

local Utils = {}

-- Generates a random integer between min and max (inclusive).
-- @param min The minimum value.
-- @param max The maximum value.
-- @return A random integer between min and max.
function Utils.random(min, max)
    return math.random(min, max)
end

-- Checks if the given piece collides with the board or other pieces.
-- @param board The game board, a 2D array representing the grid.
-- @param piece The current piece, which contains its shape and position.
-- @return True if there is a collision, false otherwise.
function Utils.checkCollision(board, piece)
    local shape = piece:getCurrentShape()
    for y = 1, #shape do
        for x = 1, #shape[y] do
            if shape[y][x] ~= 0 then
                local boardX = piece.x + x - 1
                local boardY = piece.y + y - 1
                -- Check if the piece is out of bounds
                if boardY < 1 or boardY > #board or boardX < 1 or boardX > #board[1] then
                    return true
                end
                -- Check if the piece collides with existing blocks on the board
                if boardY >= 1 and board[boardY][boardX] ~= 0 then
                    return true
                end
            end
        end
    end
    return false
end

-- Rotates the given piece.
-- @param piece The current piece to be rotated.
function Utils.rotatePiece(piece)
    piece:rotate()
end

return Utils