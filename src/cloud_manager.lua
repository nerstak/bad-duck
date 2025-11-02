Cloud = {}
Cloud.__index = Cloud

function Cloud:new(start_x)
    local cloud = {}
    setmetatable(cloud, Cloud)
    cloud.x = start_x + flr(rnd(5))
    cloud.y = 5 + flr(rnd(80))

    cloud.sprite = 10
    local r = rnd()
    if (r > 1/4 and r < 2/4) cloud.sprite = 12
    if (r> 2/4 and r < 3/4) cloud.sprite = 14
    if (r > 3/4) cloud.sprite = 42

    return cloud
end

function Cloud:draw()
    spr(self.sprite, self.x, self.y, 2, 2)
end

function Cloud:move()
    self.x -= .05
end

CloudManager = {}
CloudManager.__index = CloudManager

function CloudManager:new(n_clouds)
    local cloud_manager = {}
    setmetatable(cloud_manager, CloudManager)
    cloud_manager.clouds = {}
    for i=1, n_clouds do
        cloud_manager.clouds[i] = Cloud:new((i -1) * 60)
    end

    return cloud_manager
end

function CloudManager:update()
    for i=1,#self.clouds do 
        self.clouds[i]:move()
        if (self.clouds[i].x < -16) self.clouds[i] = Cloud:new(128)
    end
end

function CloudManager:draw()
    for i=1,#self.clouds do 
        self.clouds[i]:draw()
    end
end

