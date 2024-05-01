
-- balloons
balloons = {}
-- balloon
balloon = {
  x = 0,
  y = 0,
  size = 3,
  colour = 11,
  score = 10
}
balloon.__index = balloon
function balloon:new(o)
  return setmetatable(o or {}, self)
end
function balloon:update()
  self.x += scroll_speed
  -- move to other side on touch of walls
  if(self.x < -self.size) then 
    del(balloons, self)
  end

  if(self:collide(p)) then
    score += self.score
    del(balloons, self)
  end
end
function balloon:draw()
  circfill(self.x, self.y, self.size, self.colour)
end
function balloon:collide(o)
  return self.x >= (o.x - o.size) and self.x <= (o.x + o.size) and self.y >= (o.y - o.size) and self.y <= (o.y + o.size)
end
function balloon:init()
  self.x = max_x + self.size
  self.y = rnd(max_y)
end

