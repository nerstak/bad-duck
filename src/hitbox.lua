Hitbox = {}
Hitbox.__index = Hitbox

function Hitbox:new(topLeft_x, topLeft_y, bottomRight_x, bottomRight_y)
    local hitbox = {}
    setmetatable(hitbox, Hitbox)

    hitbox.topLeft_x = topLeft_x
    hitbox.topLeft_y = topLeft_y
    hitbox.bottomRight_x = bottomRight_x
    hitbox.bottomRight_y = bottomRight_y

    return hitbox
end

function Hitbox:verify_collision(other)
    if self.bottomRight_y < other.topLeft_y or self.topLeft_y > other.bottomRight_y then
        return false
    end
    if self.bottomRight_x < other.topLeft_x or self.topLeft_x > other.bottomRight_x then
        return false
    end
    return true
end

function Hitbox:draw()
    rect(self.topLeft_x, self.topLeft_y, self.bottomRight_x, self.bottomRight_y, 8)
end

ComplexHitbox = {}
ComplexHitbox.__index = ComplexHitbox

function ComplexHitbox:new(hitbox_array)
    local complexHitbox = {}
    setmetatable(complexHitbox, ComplexHitbox)

    complexHitbox.hitbox_array = hitbox_array

    return complexHitbox
end

function ComplexHitbox:verify_collision(other)
    for i=1,#self.hitbox_array do
        for j=1,#other.hitbox_array do
            local res = self.hitbox_array[i]:verify_collision(other.hitbox_array[j])
            if res then 
                local overlap_x = min(self.hitbox_array[i].bottomRight_x - other.hitbox_array[j].topLeft_x, other.hitbox_array[j].bottomRight_x - self.hitbox_array[i].topLeft_x)
                if (self.hitbox_array[i].topLeft_x < other.hitbox_array[j].topLeft_x) overlap_x = 0-overlap_x
                local overlap_y = min(self.hitbox_array[i].bottomRight_y - other.hitbox_array[j].topLeft_y, other.hitbox_array[j].bottomRight_y - self.hitbox_array[i].topLeft_y)
                if (self.hitbox_array[i].topLeft_y < other.hitbox_array[j].topLeft_y) overlap_y = 0-overlap_y

                return res, overlap_x,  overlap_y
            end
        end
    end
    return false, 0
end

function ComplexHitbox:draw()
    for i=1,#self.hitbox_array do
        self.hitbox_array[i]:draw()
    end
end
