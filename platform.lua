
-- starting platform
platform = { 
  x = 0,
  y = 0,
  dx = 0,
  dy = 0,
  width = 10,
  height = 3,
  colour = 6,
}
platform.__index = platform
function platform:new(o)
  return setmetatable(o or {}, self)
end
function platform:update()
  self.x += self.dx
  self.y += self.dy
end
function platform:draw()
  rectfill(self.x, self.y, self.x + self.width, self.y + self.height, self.colour)
end

