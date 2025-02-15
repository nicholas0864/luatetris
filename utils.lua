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
    for y = 1, #piece.shape do
        for x = 1, #piece.shape[y] do
            if piece.shape[y][x] ~= 0 then
                local boardX = piece.x + x - 1
                local boardY = piece.y + y - 1

                -- Check if the piece is out of bounds
                if boardX < 1 or boardX > 10 or boardY > 20 then
                    return true
                end

                -- Check if the board cell is occupied (alpha > 0 means it's filled)
                if boardY >= 1 and board[boardY][boardX][4] ~= 0 then
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