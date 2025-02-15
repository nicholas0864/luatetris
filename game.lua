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
        score = 0,  -- Add score field
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
    local linesCleared = 0
    for y = #self.board, 1, -1 do
        local isFullLine = true
        for x = 1, #self.board[y] do
            if self.board[y][x][4] == 0 then -- Check alpha instead of number
                isFullLine = false
                break
            end
        end
        if isFullLine then
            linesCleared = linesCleared + 1
            table.remove(self.board, y)
            local newRow = {}
            for i = 1, 10 do
                newRow[i] = {0, 0, 0, 0} -- Ensure new row is formatted properly
            end
            table.insert(self.board, 1, newRow)
        end
    end

    -- Update the score based on the number of lines cleared
    if linesCleared > 0 then
        self.score = self.score + (linesCleared * 100)  -- Example: 100 points per line cleared
    end
end




function Game:draw()

    -- Draw the grid background first
    love.graphics.setColor(0.2, 0.2, 0.2)  -- Dark gray color for the grid lines
    
    -- Draw vertical lines
    for x = 0, 10 do
        love.graphics.line(x * 30, 0, x * 30, 600)  -- Draw a vertical line
    end

    -- Draw horizontal lines
    for y = 0, 20 do
        love.graphics.line(0, y * 30, 300, y * 30)  -- Draw a horizontal line
    end

    -- Draw the locked pieces
    for y = 1, #self.board do
        for x = 1, #self.board[y] do
            local cell = self.board[y][x]
            if type(cell) == "table" and cell[4] ~= 0 then
                love.graphics.setColor(cell[1], cell[2], cell[3]) -- Use stored color
                love.graphics.rectangle("fill", (x - 1) * 30, (y - 1) * 30, 30, 30)
            end
        end
    end

    -- Get the ghost piece position
    local ghostY = self:getGhostPiecePosition()
    local shape = self.currentPiece:getCurrentShape()
    local color = self.currentPiece:getColor()

    -- Draw the ghost piece (semi-transparent)
    love.graphics.setColor(color[1], color[2], color[3], 0.3) -- Make it transparent
    for y = 1, #shape do
        for x = 1, #shape[y] do
            if shape[y][x] ~= 0 then
                love.graphics.rectangle("fill", (self.currentPiece.x + x - 2) * 30, (ghostY + y - 2) * 30, 30, 30)
            end
        end
    end

    -- Draw the current falling piece
    love.graphics.setColor(color)
    for y = 1, #shape do
        for x = 1, #shape[y] do
            if shape[y][x] ~= 0 then
                love.graphics.rectangle("fill", (self.currentPiece.x + x - 2) * 30, (self.currentPiece.y + y - 2) * 30, 30, 30)
            end
        end
    end

    -- Draw the score at the top of the screen
    love.graphics.setColor(1, 1, 1)  -- White color for the score
    love.graphics.setFont(love.graphics.newFont(24))  -- Set font size
    love.graphics.print("Score: " .. self.score, 10, 10)  -- Display score at (10, 10)

    love.graphics.setColor(1, 1, 1) -- Reset color to white
end




function Game:getGhostPiecePosition()
    local ghostPiece = self.currentPiece:clone()  -- Clone the current piece
    local ghostY = ghostPiece.y

    -- Move ghost piece down until it collides
    while true do
        ghostY = ghostY + 1
        ghostPiece.y = ghostY
        if Utils.checkCollision(self.board, ghostPiece) then
            ghostY = ghostY - 1
            break
        end
    end

    return ghostY
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