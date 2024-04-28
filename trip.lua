
grav = 0.5

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
  flap_accel = 4,

  max_x = 2,
  max_y = 3,
  max_grav_speed = 4
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
  if(self.dy > -self.max_y) then
    self.ddy = -self.flap_accel
  end
end

function p:update()
  self.dy += self.ddy
  self.x += self.dx
  self.y += self.dy
  self.ddy = grav

  if(self.dx > self.max_x) then self.dx = self.max_x end
  if(self.dx < -self.max_x) then self.dx = -self.max_x end
  if(self.dy > self.max_grav_speed) then self.dy = self.max_grav_speed end
  if(self.dy < -self.max_grav_speed) then self.dy = -self.max_grav_speed end

  self.dx *= 0.98

  if(self.x < 0) then self.x = 127 end
  if(self.x > 127) then self.x = 0 end
  -- bounce off ceiling
  if(self.y < self.size) then self.dy = abs(self.dy) self.y = self.size end
  -- bounce off floor
  if(self.y > 127 - self.size) then self.dy = 0.9*-abs(self.dy) self.y = 127 - self.size end
end

function _init()
  poke(0X5F5C, 255)
end

function _update()
  if (btnp(4)) then p:flap()  end
  if (btnp(5)) then p:flap()  end
  if (btn(0)) then p:move_left() end
  if (btn(1)) then p:move_right() end
  p:update()
end

function _draw()
  cls(5)
  p:draw()
end
