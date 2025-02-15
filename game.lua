local Piece = require("pieces")
local Utils = require("utils")

local Game = {}
Game.__index = Game

-- Creates a new Game instance.
-- @return A new Game instance.
function Game:new()
    local instance = {
        board = self:initializeBoard(),
        currentPiece = nil,
        isGameOver = false,
        dropTimer = 0,
        dropInterval = 0.5,
    }
    setmetatable(instance, Game)
    return instance
end

-- Initializes the game board.
-- @return A 2D array representing the game board.
function Game:initializeBoard()
    local board = {}
    for row = 1, 20 do
        board[row] = {}
        for col = 1, 10 do
            board[row][col] = {0, 0, 0, 0} -- Empty cell with transparency
        end
    end
    return board
end


-- Starts the game by spawning the first piece.
function Game:start()
    self:spawnPiece()
end

-- Spawns a new piece at the top of the board.
function Game:spawnPiece()
    local pieceTypes = {"I", "J", "L", "O", "S", "T", "Z"}
    local pieceType = pieceTypes[Utils.random(1, #pieceTypes)]
    self.currentPiece = Piece:new(pieceType)
    self.currentPiece.x = 4
    self.currentPiece.y = 1
    if Utils.checkCollision(self.board, self.currentPiece) then
        self.isGameOver = true
    end
end

-- Updates the game state.
-- @param dt The time elapsed since the last update.
function Game:update(dt)
    if not self.isGameOver then
        self.dropTimer = self.dropTimer + dt
        if self.dropTimer >= self.dropInterval then
            self.dropTimer = 0
            self:movePieceDown()
        end
    end
end

-- Moves the current piece down by one unit.
function Game:movePieceDown()
    self.currentPiece.y = self.currentPiece.y + 1
    if Utils.checkCollision(self.board, self.currentPiece) then
        self.currentPiece.y = self.currentPiece.y - 1
        self:lockPiece()
        self:clearLines()
        self:spawnPiece()
    end
end

-- Moves the current piece left by one unit.
function Game:movePieceLeft()
    self.currentPiece.x = self.currentPiece.x - 1
    if Utils.checkCollision(self.board, self.currentPiece) then
        self.currentPiece.x = self.currentPiece.x + 1
    end
end

-- Moves the current piece right by one unit.
function Game:movePieceRight()
    self.currentPiece.x = self.currentPiece.x + 1
    if Utils.checkCollision(self.board, self.currentPiece) then
        self.currentPiece.x = self.currentPiece.x - 1
    end
end

-- Rotates the current piece 90 degrees clockwise.
function Game:rotatePiece()
    Utils.rotatePiece(self.currentPiece)
    if Utils.checkCollision(self.board, self.currentPiece) then
        for i = 1, 3 do
            Utils.rotatePiece(self.currentPiece)
        end
    end
end

function Game:lockPiece()
    local color = self.currentPiece:getColor() -- Get the piece's color
    for y = 1, #self.currentPiece.shape do
        for x = 1, #self.currentPiece.shape[y] do
            if self.currentPiece.shape[y][x] ~= 0 then
                local boardX = self.currentPiece.x + x - 1
                local boardY = self.currentPiece.y + y - 1
                self.board[boardY][boardX] = {color[1], color[2], color[3], 1} -- Store the color
            end
        end
    end
end


-- Clears any full lines from the board.
function Game:clearLines()
    for y = #self.board, 1, -1 do
        local isFullLine = true
        for x = 1, #self.board[y] do
            if self.board[y][x][4] == 0 then -- Check alpha instead of number
                isFullLine = false
                break
            end
        end
        if isFullLine then
            table.remove(self.board, y)
            local newRow = {}
            for i = 1, 10 do
                newRow[i] = {0, 0, 0, 0} -- Ensure new row is formatted properly
            end
            table.insert(self.board, 1, newRow)
        end
    end
end


function Game:draw()
    for y = 1, #self.board do
        for x = 1, #self.board[y] do
            local cell = self.board[y][x]
            if type(cell) == "table" and cell[4] ~= 0 then  -- Check if it's a valid table
                love.graphics.setColor(cell[1], cell[2], cell[3]) -- Use stored color
                love.graphics.rectangle("fill", (x - 1) * 30, (y - 1) * 30, 30, 30)
            end
        end
    end

    -- Draw the current falling piece
    local shape = self.currentPiece:getCurrentShape()
    local color = self.currentPiece:getColor()
    love.graphics.setColor(color)
    for y = 1, #shape do
        for x = 1, #shape[y] do
            if shape[y][x] ~= 0 then
                love.graphics.rectangle("fill", (self.currentPiece.x + x - 2) * 30, (self.currentPiece.y + y - 2) * 30, 30, 30)
            end
        end
    end
    love.graphics.setColor(1, 1, 1) -- Reset color to white
end



-- Handles key presses to control the game.
-- @param key The key that was pressed.
function Game:keypressed(key)
    if key == "left" then
        self:movePieceLeft()
    elseif key == "right" then
        self:movePieceRight()
    elseif key == "down" then
        self:movePieceDown()
    elseif key == "up" then
        self:rotatePiece()
    elseif key == "space" then
        while not Utils.checkCollision(self.board, self.currentPiece) do
            self.currentPiece.y = self.currentPiece.y + 1
        end
        self.currentPiece.y = self.currentPiece.y - 1
        self:lockPiece()
        self:clearLines()
        self:spawnPiece()
    end
end

return Game