local Utils = {}

function Utils.random(min, max)
    return math.random(min, max)
end

function Utils.checkCollision(board, piece)
    local shape = piece:getCurrentShape()
    for y = 1, #shape do
        for x = 1, #shape[y] do
            if shape[y][x] ~= 0 then
                local boardX = piece.x + x - 1
                local boardY = piece.y + y - 1
                if boardY < 1 or boardY > #board or boardX < 1 or boardX > #board[1] then
                    return true
                end
                if boardY >= 1 and board[boardY][boardX] ~= 0 then
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