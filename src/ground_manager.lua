GroundBlock = {}
GroundBlock.__index = GroundBlock

function GroundBlock:new(x, y)
    local ground_block = {}
    setmetatable(ground_block, GroundBlock)
    ground_block.x = x
    ground_block.y = y
    ground_block:reset()

    return ground_block
end

function GroundBlock:reset()
    self.sprite = 0
    self.should_reverse = false

    local s = 100
    local r = flr(rnd(s))
    if (r < 10) self.sprite = 5
    if (r < 40 and r >= 35) self.sprite = 6
    if (r < 45 and r >= 40) self.sprite = 7
    if (r < 50 and r >= 45) self.sprite = 8
    if (r < 55 and r >= 50) self.sprite = 9
    if (r % 2 == 0) self.should_reverse = true
end

function GroundBlock:draw()
    spr(4, self.x, self.y)
    if (self.sprite != 0) spr(self.sprite, self.x, self.y-3, 1, 1, self.should_reverse)
end

GroundManager = {}
GroundManager.__index = GroundManager

function GroundManager:new()
    local ground_manager = {}
    setmetatable(ground_manager, GroundManager)
    ground_manager.blocks = {}
    for i=1,18 do
        ground_manager.blocks[i] = GroundBlock:new((i -1) * 8, 128 - 8)
    end
    return ground_manager
end

function GroundManager:draw()
    for i=1,#self.blocks do
        self.blocks[i]:draw()
    end
end

function GroundManager:update()
    for i=1,#self.blocks do
        self.blocks[i].x -= 1
        if self.blocks[i].x <= -8 then
            self.blocks[i].x += 8 * #self.blocks
            self.blocks[i]:reset()
        end
    end
end
