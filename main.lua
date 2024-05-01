
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
  -- change pallete for colour 0
  pal(0,129,1)

  -- disable btnp repeats
  poke(0X5F5C, 255)

  -- create stars
  for i = 0,25 do
    s = star:new({
        x = rnd(max_x),
        y = rnd(max_y),
        size = 0,
        colour = rnd({1, 13})
      })
    add(stars, s)
  end
end

function _update()
  if not started then
    if (btnp(4)) then start() end
    if (btnp(5)) then start() end
  elseif not ended then
    timer += 1 
    score += 1 / 30
    
    if(flr(timer) % 25 == 0 and flr(rnd(7)) == 1) then
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
    print("game over", max_x / 2 - 15, max_y / 2, 7)
  end
end
