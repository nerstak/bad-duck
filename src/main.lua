data_bckt = {}
show_hitboxes = false

function start()
    data_bckt.player = Player:new(31, 1, 16, 16)
    data_bckt.pipe_manager = PipeManager:new(3, 3, 10)
    data_bckt.ground_manager = GroundManager:new()
    data_bckt.cloud_manager = CloudManager:new(3)
    data_bckt.boundaries = {
        ComplexHitbox:new({Hitbox:new(0,-1,127,-1)}),
        ComplexHitbox:new({Hitbox:new(0,127-3,127,127-3)}),
    }
end

function _init()
    cls(12)
    start()
end

function _update()
    if data_bckt.player.is_dead and (btn(4) or btn(5)) then
        start()
    end

    data_bckt.ground_manager:update()
    data_bckt.cloud_manager:update()

    local p_hitbox = data_bckt.player:hitbox()
    if not data_bckt.player.is_dead then
        for i=1,#data_bckt.boundaries do
            local boundary_collision, _ = p_hitbox:verify_collision(data_bckt.boundaries[i])
            if (boundary_collision and not data_bckt.player.is_dead) sfx(1,1)
            data_bckt.player.is_dead = data_bckt.player.is_dead or boundary_collision
        end
        
        for i = 1, #data_bckt.pipe_manager.pipes do 
            if data_bckt.pipe_manager.pipes[i].is_visible then
                local pipes_hitboxes = data_bckt.pipe_manager.pipes[i]:pipes_hitboxes()
                for j = 1, #pipes_hitboxes do
                    local pipe_collision, _ = p_hitbox:verify_collision(pipes_hitboxes[j])
                    if (pipe_collision and not data_bckt.player.is_dead) sfx(1,1)
                    data_bckt.player.is_dead = data_bckt.player.is_dead or pipe_collision
                end
                local score_hitbox = data_bckt.pipe_manager.pipes[i]:scoreHitbox()
                local score_collision, _ = p_hitbox:verify_collision(score_hitbox)
                if score_collision and data_bckt.pipe_manager.pipes[i].scoring_enabled then
                    data_bckt.pipe_manager.pipes[i].scoring_enabled = false
                    data_bckt.player.score += 1
                end
            end
        end
    end
    

    local jump = false
    if not data_bckt.player.is_dead then 
        jump = btn(2)
        if (jump and data_bckt.player.buffer_jump == 0) sfx(0,0,0,11)
    end
    data_bckt.player:move(false, false, jump)
    data_bckt.pipe_manager:update()

    local p_hitbox = data_bckt.player:hitbox()
    for i = 1, #data_bckt.pipe_manager.pipes do 
        if data_bckt.pipe_manager.pipes[i].is_visible then
            local pipes_hitboxes = data_bckt.pipe_manager.pipes[i]:pipes_hitboxes()
            for j = 1, #pipes_hitboxes do
                local pipe_collision, overlap_x, overlap_y = p_hitbox:verify_collision(pipes_hitboxes[j])
                if pipe_collision then
                    if abs(overlap_x) < abs(overlap_y) then
                        data_bckt.player.x += overlap_x
                    else
                        data_bckt.player.y += overlap_y
                    end
                end
            end
        end
    end
end

function _draw()
    cls(12)
    data_bckt.cloud_manager:draw()
    data_bckt.player:draw()
    for i = 1, #data_bckt.pipe_manager.pipes do 
        data_bckt.pipe_manager.pipes[i]:draw()
        if show_hitboxes then
            data_bckt.pipe_manager.pipes[i]:scoreHitbox():draw()
            local hitboxes = data_bckt.pipe_manager.pipes[i]:pipes_hitboxes()
            for j = 1, #hitboxes do
                hitboxes[j]:draw()
            end
        end
    end
    if (show_hitboxes) data_bckt.player:hitbox():draw()

    draw_text_with_borders('score: ' .. data_bckt.player.score, 4, 5, 7, 1, 7)
    if data_bckt.player.is_dead then
        draw_text_with_borders('you died', 47, 58, 7, 1, 7)
        draw_text_with_borders('press x button to restart', 15, 70, 7, 1, 7)
    end
    data_bckt.ground_manager:draw()

end
