
-- player
player = {
  lives = 3,

  size = 4,
  x = 64,
  y = 64,
  dx = 0,
  dy = 0,
  ddx = 0,
  ddy = 0,

  x_accel = 0.5,
  y_accel = 1.5,

  max_x_speed = 2,
  max_y_speed = 2,
  max_grav_speed = 2,

  x_resist = 0.98,

  visible = true,

  -- coroutines
  invincible = nil,
  game_over = nil
}

function player:stop()
  self.dx = 0
  self.dy = 0
  self.ddx = 0
  self.ddy = 0
end

function player:damage()
  self.lives -= 1

  self.invincible = cocreate(function()

    self.visible = false

    for i = 1,5 do
      for j = 1,5 do
        yield()
      end
      self.visible = (i % 2 == 1)
    end

  end)
end

function player:draw()
  if self.visible then
    circfill(self.x, self.y, self.size, 7)
  end
end

function player:move_left()
  if(self.ddy < 0) then
    self.ddx = -self.x_accel
  else
    self.ddx = 0
  end
end

function player:move_right()
  if(self.ddy < 0) then
    self.ddx = self.x_accel
  else
    self.ddx = 0
  end
end

function player:collide(o)
  return ((self.x - self.size) <= (o.x + o.size) and
          (self.x + self.size) >= (o.x - o.size) and
          (self.y - self.size) <= (o.y + o.size) and
          (self.y + self.size) >= (o.y - o.size))
end

function player:flap()
  if(self.dy > -self.max_y_speed) then
    self.ddy = -self.y_accel
  end
end

function player:update()
  self.dy += self.ddy
  self.dx += self.ddx
  self.x += self.dx
  self.y += self.dy

  if(self.dx > self.max_x_speed) then self.dx = self.max_x_speed end
  if(self.dx < -self.max_x_speed) then self.dx = -self.max_x_speed end
  if(self.dy > self.max_grav_speed) then self.dy = self.max_grav_speed end
  if(self.dy < -self.max_grav_speed) then self.dy = -self.max_grav_speed end

  -- slow down x speed over time
  self.dx *= self.x_resist
  -- stop completely
  if(abs(self.dx) < 0.01) then self.dx = 0 end

  -- bounce off ceiling
  if(self.y < self.size) then self.dy = abs(self.dy) self.y = self.size end

  -- stop on left/right walls
  if(self.x < self.size) then self.dx = 0 self.x = self.size end
  if(self.x > max_x - self.size) then self.dx = 0 self.x = max_x - self.size end

  if self.invincible and costatus(self.invincible) != 'dead' then
    coresume(self.invincible)
  else
    self.invincible = nil
  end
end
