
-- platforms
platforms = {}
-- starting platform
platform = { 
  x = 0,
  y = 0,
  width = 10,
  height = 3,
  colour = 6,
  dx = scroll_speed,
  dy = 0,
}
platform.__index = platform
function platform:new(o)
  return setmetatable(o or {}, self)
end
function platform:draw()
  rectfill(self.x, self.y, self.x + self.width, self.y + self.height, self.colour)
end

-- starting platform
start_platform = platform:new({
    x = max_x / 2 - 4,
    y = max_y / 2 + 6
  })
add(platforms, start_platform)

