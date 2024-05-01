
-- balloon
balloon = {
  x = 0,
  y = 0,
  dx = 0,
  dy = 0,
  size = 3,
  colour = 11,
  score = 10
}
balloon.__index = balloon
function balloon:new(o)
  return setmetatable(o or {}, self)
end
function balloon:update()
  self.x += self.dx
  self.y += self.dy
end
function balloon:draw()
  circfill(self.x, self.y, self.size, self.colour)
end
function balloon:init()
  self.x = max_x + self.size
  self.y = rnd(max_y)
end

