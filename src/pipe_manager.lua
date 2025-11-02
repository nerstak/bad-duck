function generate_upper_size()
    return flr(rnd(6))
end

PairPipes = {}
PairPipes.__index = PairPipes

function PairPipes:new(upper_size, lower_size, x, x_size, y_size)
    local pair_pipes = {}
    setmetatable(pair_pipes, PairPipes)
    pair_pipes.upper_size = upper_size
    pair_pipes.lower_size = lower_size
    pair_pipes.x_size = x_size
    pair_pipes.y_size = y_size
    pair_pipes.x = x
    pair_pipes.scoring_enabled = true
    pair_pipes.is_visible = false
    return pair_pipes
end

function PairPipes:draw()
    if self.is_visible then
        -- Top pipe
        for i=0,self.upper_size-2 do
            spr(20, self.x, i * 8 * self.y_size, self.x_size ,self.y_size)
        end
        spr(18, self.x, (self.upper_size -1) * 8 * self.y_size, self.x_size ,self.y_size, false, true)

        -- Bottom pipe
        for i=0,self.lower_size-1 do
            spr(20, self.x, 127 - i * 8 * self.y_size, self.x_size ,self.y_size)
        end
        spr(18, self.x, 127-8*self.lower_size*self.y_size, self.x_size ,self.y_size)
    end
end

function PairPipes:pipes_hitboxes()
    return {
        ComplexHitbox:new({
            Hitbox:new(self.x+3, 0, self.x + 12, self.upper_size * 8 * self.y_size - 1), -- Tube
            Hitbox:new(self.x, (self.upper_size -1) * 8 *self.y_size + 8, self.x + 8 * self.x_size, 8 * self.upper_size * self.y_size) -- Head
        }),
        ComplexHitbox:new({
            Hitbox:new(self.x+3, 127 - 8 * self.lower_size * self.y_size, self.x + 12, 127), -- Tube
            Hitbox:new(self.x, 127 - 8 * self.lower_size * self.y_size, self.x + 8 * self.x_size, 127 - 8 * self.lower_size * self.y_size + 7) -- Head
        })
    }
end

function PairPipes:scoreHitbox()
    return ComplexHitbox:new({Hitbox:new(self.x + 8, 8 * self.upper_size * self.y_size, self.x + 8, 127 - 8 * self.lower_size * self.y_size)})
end


PipeManager = {}
PipeManager.__index = PipeManager

function PipeManager:new(x_spacing, y_spacing, max_pipes)
    local pipe_manager = {}
    setmetatable(pipe_manager, PipeManager)
    pipe_manager.pipe_x_size = 2
    pipe_manager.pipe_y_size = 2
    pipe_manager.pipes = {}
    for i=1,max_pipes do
        local upper_size = generate_upper_size()
        pipe_manager.pipes[i] = PairPipes:new(upper_size, 8 - upper_size - y_spacing, 0, pipe_manager.pipe_x_size, pipe_manager.pipe_y_size)
    end
    pipe_manager.pipes = shuffle(pipe_manager.pipes)

    for i=1,max_pipes do
        pipe_manager.pipes[i].x = 75 + i * x_spacing * pipe_manager.pipe_x_size * 8
    end
    pipe_manager.x_spacing = x_spacing
    pipe_manager.y_spacing = y_spacing
    pipe_manager.max_pipes = max_pipes
    return pipe_manager
end

function PipeManager:update()
    for i=1,#self.pipes do 
        self.pipes[i].x-=1
        if self.pipes[i].x < -8 * self.pipe_x_size then 
            self.pipes[i].x = self.pipes[i].x + self.max_pipes * self.x_spacing * self.pipe_x_size * 8 
            local upper_size = generate_upper_size()
            self.pipes[i].upper_size = upper_size
            self.pipes[i].lower_size = 8 - upper_size - self.y_spacing
            self.pipes[i].scoring_enabled = true
            self.pipes[i].is_visible = false
        end
        if self.pipes[i].x < 127 then
            self.pipes[i].is_visible = true
        end
    end
end