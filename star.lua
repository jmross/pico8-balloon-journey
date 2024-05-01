
-- stars
stars ={}
-- star
star = {
  x = 0,
  y = 0,
  size = 0,
  colour = 1,
}
star.__index = star
function star:new(o)
  return setmetatable(o or {}, self)
end
function star:update()
  self.x += scroll_speed
  -- move to other side on touch of walls
  if(self.x < -self.size) then 
    self.x = max_x + self.size
    self.y = rnd(max_y)
  end
end
function star:draw()
  circfill(self.x, self.y, self.size, self.colour)
end

