
min_x = 0
min_y = 0
max_x = 127
max_y = 127

grav = 0
x_resist = 0.98
scroll_speed = -1
started = false
ended = false
score = 0
timer = 0

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

-- enemies
enemies = {}
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

  if(self:collide(p)) then
    p:damage()
    self:init()
  end
end

function enemy:draw()
  circfill(self.x, self.y, self.size, 14)
end

function enemy:new(o)
  return setmetatable(o or {}, self)
end

function enemy:collide(o)
  return self.x >= (o.x - o.size) and self.x <= (o.x + o.size) and self.y >= (o.y - o.size) and self.y <= (o.y + o.size)
end

function enemy:init()
  self.x = max_x + 1
  self.y = rnd(max_y)
  self.dx = -rnd(2)
  -- TODO
  self.dy = rnd(1) + (flr(rnd(2)) * -1)
end

-- platforms
platforms = {}
-- starting platform
platform = { 
  x = 0,
  y = 0,
  width = 10,
  height = 3,
  colour = 14,
  dx = scroll_speed,
  dy = 0,
}
platform.__index = platform
function platform:new(o)
  return setmetatable(o or {}, self)
end
function platform:draw()
  rectfill(self.x, self.y, self.x + self.width, self.y + self.height, self.colour)
end

-- starting platform
start_platform = platform:new({
    x = max_x / 2 - 4,
    y = max_y / 2 + 5
  })
add(platforms, start_platform)

-- stars
stars ={}
-- star
star = {
  x = 0,
  y = 0,
  size = 0,
  colour = 10,
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

-- balloons
balloons = {}
-- balloon
balloon = {
  x = 0,
  y = 0,
  size = 3,
  colour = 11,
  score = 10
}
balloon.__index = balloon
function balloon:new(o)
  return setmetatable(o or {}, self)
end
function balloon:update()
  self.x += scroll_speed
  -- move to other side on touch of walls
  if(self.x < -self.size) then 
    del(balloons, self)
  end

  if(self:collide(p)) then
    score += self.score
    del(balloons, self)
  end
end
function balloon:draw()
  circfill(self.x, self.y, self.size, self.colour)
end
function balloon:collide(o)
  return self.x >= (o.x - o.size) and self.x <= (o.x + o.size) and self.y >= (o.y - o.size) and self.y <= (o.y + o.size)
end
function balloon:init()
  self.x = max_x + self.size
  self.y = rnd(max_y)
end

-- game
function start()
  started = true
  grav = 0.25
  del(platforms, start_platform)

  -- create enemies
  for i = 0,7 do
    e = enemy:new()
    e:init()
    add(enemies, e)
  end
end
function lose()
  ended = true 
end

function _init()
  -- disable btnp repeats
  poke(0X5F5C, 255)

  -- create stars
  for i = 0,35 do
    s = star:new({
        x = rnd(max_x),
        y = rnd(max_y),
        size = rnd(1.5)
      })
    add(stars, s)
  end
end

function _update()
  if not started then
    if (btnp(4)) then start() end
    if (btnp(5)) then start() end
  elseif not ended then
    timer += 1 / 30
    score += 1 / 30
    
    printh(timer * 30)

    if(flr(timer * 30) % 25 == 0 and flr(rnd(7)) == 1) then
      b = balloon:new()
      b:init()
      add(balloons, b)
    end

    if (btnp(4)) then p:flap()  end
    if (btnp(5)) then p:flap()  end
    if (btn(0)) then p:move_left() end
    if (btn(1)) then p:move_right() end

    for s in all(stars) do
      s:update()
    end
    for e in all(enemies) do
      e:update()
    end
    for b in all(balloons) do
      b:update()
    end
    p:update()
  end
end

function _draw()
  cls(0)
  for s in all(stars) do
    s:draw()
  end
  for e in all(enemies) do
    e:draw()
  end
  for pl in all(platforms) do
    pl:draw()
  end
  for b in all(balloons) do
    b:draw()
  end
  p:draw()

  -- lives
  print("lives: "..p.lives, 8, 8, 7)

  -- score
  print("score: "..flr(score), 8, 16, 7)

  -- water
  rectfill(0, max_y, max_x, max_y - 10, 12)

  if ended then
    print("you lose!", max_x / 2 - 15, max_y / 2, 7)
  end
end
