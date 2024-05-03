
-- enemy
enemy = {
  width = sprite_width,
  height = sprite_height,
  size = 2, -- remove
  x = 0,
  y = 0,
  dx = 0,
  dy = 0,
  sprite = 4,
  sprites = {4, 5, 6, 7, 8},
  -- coroutines
  animate = nil
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
  if(self.x < min_x - self.size) then 
    self:init()
  end

  if self.animate and costatus(self.animate) != 'dead' then
    coresume(self.animate)
  end
end

function enemy:draw()
  spr(self.sprite, self.x, self.y)
end

function enemy:new(o)
  return setmetatable(o or {}, self)
end

function enemy:init()
  self.x = max_x + 1
  self.y = rnd(max_y)
  self.dx = -rnd(2)
  self.dy = rnd(1) * rnd({-1, 1})

  self.animate = cocreate(function()
    local i = 0
    while true do
      i += 1
      self.sprite = self.sprites[i % count(self.sprites) + 1]
      yield()
    end
  end)
end
