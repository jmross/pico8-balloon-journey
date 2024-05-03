
-- player
player = {
  lives = 3,

  x = 0,
  y = 0,
  dx = 0,
  dy = 0,
  ddx = 0,
  ddy = 0,

  width = sprite_width,
  height = 2 * sprite_height,

  top_sprite = 0,
  bottom_sprite = 16,
  bottom_sprites = {16, 17, 18},
  death_sprite = 19,

  facing_left = false,

  x_accel = 0.25,
  y_accel = 1,

  max_x_speed = 2,
  max_y_speed = 2,
  max_grav_speed = 2,

  x_resist = 0.98,

  visible = true,

  -- coroutines
  invincible = nil,
  flying = nil,
  animate = nil,
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
      delay(5)
      self.visible = (i % 2 == 1)
    end

  end)
end

function player:draw()
  if self.visible then
    if self.lives > 0 then
      spr(self.top_sprite, self.x, self.y, 1, 1, self.facing_left, false)
    else
      self.bottom_sprite = self.death_sprite
    end
    spr(self.bottom_sprite, self.x, self.y + sprite_height, 1, 1, self.facing_left, false)
  end
end

function player:move_left()
  self.facing_left = true
  if(self.ddy < 0) then
    self.ddx = -self.x_accel
  else
    self.ddx = 0
  end
end

function player:move_right()
  self.facing_left = false
  if(self.ddy < 0) then
    self.ddx = self.x_accel
  else
    self.ddx = 0
  end
end

function player:collide(o)
  return (self.x <= (o.x + o.width) and
          (self.x + self.width) >= o.x and
          self.y <= (o.y + o.height) and
          (self.y + self.height) >= o.y)
end

function player:fly()
  player:flap()
  self.flying = cocreate(function()
    delay(5)
    while true do
      player:flap()
      delay(5)
    end
  end)
end

function player:flap()
  self.animate = cocreate(function()
    yield()
    self.bottom_sprite = self.bottom_sprites[2]
    yield()
    self.bottom_sprite = self.bottom_sprites[3]
    yield()
    self.bottom_sprite = self.bottom_sprites[1]
  end)

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
  if(self.y < min_y) then self.dy = abs(self.dy) end

  -- stop on left/right walls
  if(self.x < min_x) then self.dx = 0 self.x = min_x end
  if(self.x + self.width > max_x) then self.dx = 0 self.x = max_x - self.width end

  if self.invincible and costatus(self.invincible) != 'dead' then
    coresume(self.invincible)
  else
    self.invincible = nil
  end

  if self.animate and costatus(self.animate) != 'dead' then
    coresume(self.animate)
  else
    self.animate = nil
  end
end
