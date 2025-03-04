

local Piece = {}
Piece.__index = Piece

-- @param type The type of the piece (one of "I", "J", "L", "O", "S", "T", "Z").
function Piece:new(type)
    local shapes = {
        I = {{1, 1, 1, 1}},
        J = {{1, 0, 0}, {1, 1, 1}},
        L = {{0, 0, 1}, {1, 1, 1}},
        O = {{1, 1}, {1, 1}},
        S = {{0, 1, 1}, {1, 1, 0}},
        T = {{0, 1, 0}, {1, 1, 1}},
        Z = {{1, 1, 0}, {0, 1, 1}}
    }
    local colors = {
        I = {0, 1, 1},  -- Cyan
        J = {0, 0, 1},  -- Blue
        L = {1, 0.5, 0},  -- Orange
        O = {1, 1, 0},  -- Yellow
        S = {0, 1, 0},  -- Green
        T = {0.5, 0, 0.5},  -- Purple
        Z = {1, 0, 0}  -- Red
    }
    local instance = {
        shape = shapes[type],
        color = colors[type],
        x = 0,
        y = 0,
        rotation = 1
    }
    setmetatable(instance, Piece)
    return instance
end

-- Gets the current shape of the piece.
-- @return The current shape of the piece.
function Piece:getCurrentShape()
    return self.shape
end

-- Gets the color of the piece.
-- @return The color of the piece.
function Piece:getColor()
    return self.color
end

-- Rotates the piece 90 degrees clockwise.
function Piece:rotate()
    local newShape = {}
    for y = 1, #self.shape[1] do
        newShape[y] = {}
        for x = 1, #self.shape do
            newShape[y][x] = self.shape[#self.shape - x + 1][y]
        end
    end
    self.shape = newShape
end

function Piece:clone()
    local newPiece = Piece:new(self.type)
    newPiece.x = self.x
    newPiece.y = self.y
    newPiece.shape = {}
    for i = 1, #self.shape do
        newPiece.shape[i] = {}
        for j = 1, #self.shape[i] do
            newPiece.shape[i][j] = self.shape[i][j]
        end
    end
    return newPiece
end



return Piece