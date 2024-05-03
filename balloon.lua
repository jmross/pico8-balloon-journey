
-- balloon
balloon = {
  x = 0,
  y = 0,
  dx = 0,
  dy = 0,
  width = sprite_width,
  height = 2 * sprite_height,
  size = 3, -- remove
  colour = 11,
  score = 10,

  sprite_top = 1,
  sprite_bottom = 2,
  sprite_bottoms = {2, 3},

  -- coroutines
  animate = nil,
}
balloon.__index = balloon

function balloon:new(o)
  return setmetatable(o or {}, self)
end

function balloon:update()
  self.x += self.dx
  self.y += self.dy

  if self.animate and costatus(self.animate) != 'dead' then
    coresume(self.animate)
  end
end

function balloon:draw()
  spr(self.sprite_top, self.x, self.y)
  spr(self.sprite_bottom, self.x, self.y + sprite_height)
end

function balloon:init()
  self.x = max_x + self.size
  self.y = rnd(max_y)
  self.sprite_bottom = rnd(self.sprite_bottoms)
  local dx = self.dx

  self.animate = cocreate(function()
    local i = 0
    while true do
      i += 1
      self.sprite_bottom = self.sprite_bottoms[i % count(self.sprite_bottoms) + 1]
      if i % 2 == 0 then
        self.dx = dx + rnd(0.1) * -1
        self.dy = rnd(0.1) * -1
      else
        self.dx = dx + rnd(0.1)
        self.dy = rnd(0.1)
      end
      delay(30)
    end
  end)
end

