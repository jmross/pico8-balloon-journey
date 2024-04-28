
min_x = 0
min_y = 0
max_x = 127
max_y = 127

grav = 0.25
x_resist = 0.98

-- player
p = {
  size = 3,
  x = 64,
  y = 64,
  dx = 0,
  dy = 0,
  ddx = 0,
  ddy = 0,

  x_accel = 0.5,
  y_accel = 3,

  max_x_speed = 2,
  max_y_speed = 3,
  max_grav_speed = 3
}

function p:draw()
  circfill(self.x, self.y, self.size, 14)
end

function p:move_left()
  if(self.ddy < 0) then
    self.ddx = -self.x_accel
    self.dx += self.ddx
  end
end

function p:move_right()
  if(self.ddy < 0) then
    self.ddx = self.x_accel
    self.dx += self.ddx
  end
end

function p:flap()
  if(self.dy > -self.max_y_speed) then
    self.ddy = -self.y_accel
  end
end

function p:update()
  self.dy += self.ddy
  self.x += self.dx
  self.y += self.dy
  self.ddy = grav

  if(self.dx > self.max_x_speed) then self.dx = self.max_x_speed end
  if(self.dx < -self.max_x_speed) then self.dx = -self.max_x_speed end
  if(self.dy > self.max_grav_speed) then self.dy = self.max_grav_speed end
  if(self.dy < -self.max_grav_speed) then self.dy = -self.max_grav_speed end

  -- slow down x speed over time
  self.dx *= x_resist
  -- stop completely
  if(abs(self.dx) < 0.01) then self.dx = 0 end

  -- bounce off ceiling
  if(self.y < self.size) then self.dy = 0.5*abs(self.dy) self.y = self.size end
  -- lose if touch floor
  if(self.y > max_y - self.size) then
    printh("YOU LOSE")
    self.y = max_y - self.size
    self.dx = 0
    self.dy = 0
    self.ddx = 0
    self.ddy = 0
  end

  -- stop on left/right walls
  if(self.x < self.size) then self.dx = 0 self.x = self.size end
  if(self.x > max_x - self.size) then self.dx = 0 self.x = max_x - self.size end
end

-- enemies
enemies = {}
-- enemy
enemy = {
  size = 1,
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

  -- stop on left/right walls
  if(self.x < self.size) then self.dx = abs(self.dx) self.x = self.size end
  if(self.x > max_x - self.size) then self.dx = -abs(self.dx) self.x = max_x - self.size end
end
function enemy:draw()
  circfill(self.x, self.y, self.size, 14)
end
function enemy:new(o)
  return setmetatable(o or {}, self)
end

function _init()
  -- disable btnp repeats
  poke(0X5F5C, 255)

  for i = 0,5 do
    e = enemy:new({
        x = rnd(127),
        y = rnd(127),
        dx = rnd(1),
        dy = rnd(1)
      })
    add(enemies, e)
  end
end

function _update()
  if (btnp(4)) then p:flap()  end
  if (btnp(5)) then p:flap()  end
  if (btn(0)) then p:move_left() end
  if (btn(1)) then p:move_right() end
  p:update()
  for e in all(enemies) do
    e:update()
  end
end

function _draw()
  cls(5)
  p:draw()
  for e in all(enemies) do
    e:draw()
  end
end
