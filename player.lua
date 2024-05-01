
-- player
p = {
  lives = 3,

  size = 4,
  x = 64,
  y = 64,
  dx = scroll_speed,
  dy = 0,
  ddx = 0,
  ddy = 0,

  x_accel = 0.5,
  y_accel = 3,

  max_x_speed = 2,
  max_y_speed = 3,
  max_grav_speed = 3
}

function p:damage()
  self.lives -= 1
  if(self.lives <= 0) then
    lose()
  end
end

function p:draw()
  circfill(self.x, self.y, self.size, 7)
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

  -- damage if touch floor
  if(self.y > max_y - self.size) then
    self.y = max_y - self.size
    self:damage()
  end

  -- stop on left/right walls
  if(self.x < self.size) then self.dx = 0 self.x = self.size end
  if(self.x > max_x - self.size) then self.dx = 0 self.x = max_x - self.size end
end
