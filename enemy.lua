
-- enemy
enemy = {
  size = 2,
  x = 0,
  y = 0,
  dx = 0,
  dy = 0,
}
enemy.__index = enemy
function enemy:update()
  self.x += self.dx
  self.y += self.dy
  -- bounce off ceiling
  if(self.y < self.size) then self.dy = abs(self.dy) self.y = self.size end
  -- bounce off floor
  if(self.y > max_y - self.size) then self.dy = -abs(self.dy) self.y = max_y - self.size end

  -- re-init on touch of walls
  if(self.x < -self.size) then 
    self:init()
  end
end

function enemy:draw()
  circfill(self.x, self.y, self.size, 14)
end

function enemy:new(o)
  return setmetatable(o or {}, self)
end

function enemy:init()
  self.x = max_x + 1
  self.y = rnd(max_y)
  self.dx = -rnd(2)
  self.dy = rnd(1) * rnd({-1, 1})
end
