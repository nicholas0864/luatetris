

local Utils = {}


function Utils.random(min, max)
    return math.random(min, max)
end

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

function Utils.rotatePiece(piece)
    piece:rotate()
end

return Utils