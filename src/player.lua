Player = {}
Player.__index = Player

function Player:new(x,y, size_x, size_y)
    local player = {}
    setmetatable(player, Player)
    player.x = x
    player.y = y
    player.size_x = size_x
    player.size_y = size_y
    player.dx = 0
    player.dy = 0
    player.buffer_jump = 0
    player.score = 0
    player.is_dead = false
    return player
end

function Player:move(left, right, jump)
    local ddx = 0
    if (self.buffer_jump > 0) self.buffer_jump -= 1

    if (left) ddx = -.25
    if (right) ddx = .25
    if jump and self.buffer_jump == 0 then
        self.buffer_jump = 6
        self.dy = -5
    end

    self.dx+=ddx
    if self.dx > 3 then
        self.dx = 3
    elseif self.dx < -3 then
        self.dx = -3
    end
    if ddx == 0 then
        self.dx*=0.8
    end

    self.dy+=0.75--0.98

    self:moveX(self.dx)
    self:moveY(self.dy)

    if (self.y == 128 - self.size_y) dy = 0 
end

function Player:moveX(value)
    local newVal = self.x + value
    if newVal > 128 - self.size_x then
        newVal = 128 - self.size_x
        self.dx = 0
    end
    if newVal < 0 then
        -- newVal = 0
        self.dx = 0
    end
    self.x = newVal
end

function Player:moveY(value)
    local newVal = self.y + value
    if (newVal > 128 - self.size_y) newVal = 128 - self.size_y
    if (newVal < -1) newVal = -1
    self.y = newVal
end

function Player:draw()
    if self.is_dead then
        spr(16, self.x, self.y, 2, 2, false, true)
    else
        spr(16, self.x, self.y,2,2)
        if self.dy < 0 then
            pset(self.x+12, self.y+1,2)
        else
            pset(self.x+12, self.y+2,2)
        end
    end
end

function Player:hitbox()
    return ComplexHitbox:new({
        Hitbox:new(self.x+1, self.y+4, self.x+self.size_x - 3, self.y+12), -- Body
        Hitbox:new(self.x+8, self.y, self.x+14, self.y+4), -- Head
    })
end