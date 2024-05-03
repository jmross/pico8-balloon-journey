
-- enemy
enemy = {
  width = sprite_width,
  height = sprite_height,
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
  if(self.y < min_y) then self.dy = abs(self.dy) self.y = min_y end
  -- bounce off floor
  if(self.y + self.height > max_y) then self.dy = -abs(self.dy) self.y = max_y - self.height end

  -- re-init on touch of walls
  if(self.x + self.width < min_x) then 
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
