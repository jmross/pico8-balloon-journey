
min_x = 0
min_y = 0
max_x = 127
max_y = 127

stars = {}
enemies = {}
platforms = {}
balloons = {}

-- game
game = {
  grav = 0,
  scroll_speed = -1,
  started = false,
  ended = false,
  score = 0,
  timer = 0,

  start = function(this)
    this.started = true
    this.grav = 0.25
    player.dx = game.scroll_speed
    del(platforms, start_platform)

    -- create enemies
    for i = 0,7 do
      e = enemy:new()
      e:init()
      add(enemies, e)
    end
  end,

  lose = function(this)
    this.ended = true 
  end,
}

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
        colour = rnd({1, 13}),
        dx = game.scroll_speed,
      })
    add(stars, s)
  end

  -- starting platform
  start_platform = platform:new({
      x = max_x / 2 - 4,
      y = max_y / 2 + 6
    })
  add(platforms, start_platform)

end

function _update()
  if not game.started then
    if (btnp(4)) then game:start() end
    if (btnp(5)) then game:start() end
  elseif not game.ended then
    game.timer += 1 
    game.score += 1 / 30
    
    if(flr(game.timer) % 25 == 0 and flr(rnd(7)) == 1) then
      b = balloon:new()
      b.dx = game.scroll_speed
      b:init()
      add(balloons, b)
    end

    if (btnp(4)) then player:flap()  end
    if (btnp(5)) then player:flap()  end
    if (btn(0)) then player:move_left() end
    if (btn(1)) then player:move_right() end

    for s in all(stars) do
      s:update()
    end

    for e in all(enemies) do
      e:update()
      if(not player.invincible and player:collide(e)) then
        player:damage()
        e:init()
      end
    end

    for p in all(platforms) do
      p:update()
    end

    for b in all(balloons) do
      b:update()
      if(player:collide(b)) then
        game.score += b.score
        del(balloons, b)
      end

      -- move to other side on touch of walls
      if(b.x < -b.size) then 
        del(balloons, b)
      end
    end

    player:update()

    if(player.lives <= 0) then
      game:lose()
    end

    player.ddy = game.grav
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

  for p in all(platforms) do
    p:draw()
  end

  for b in all(balloons) do
    b:draw()
  end
  player:draw()

  -- lives
  print("lives: "..player.lives, 8, 8, 7)

  -- score
  print("score: "..flr(game.score), 8, 16, 7)

  -- water
  rectfill(0, max_y, max_x, max_y - 10, 12)

  if game.ended then
    print("game over", max_x / 2 - 15, max_y / 2, 7)
  end
end
