shake_intensity = 0
shake_control = 5

function shake()
    local shake_x=rnd(shake_intensity) - (shake_intensity /2)
    local shake_y=rnd(shake_intensity) - (shake_intensity /2)

    --offset the camera
    camera( shake_x, shake_y )

    --ease shake and return to normal
    shake_intensity *= .9
    if shake_intensity < .3 then shake_intensity = 0 end
end

function delay(i)
  for i = 1,i do
    yield()
  end
end

min_x = 0
min_y = 0
max_x = 127
max_y = 127
sprite_width = 8
sprite_height = 8

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
  game_over = false,
  score = 0,
  timer = 0,

  start_message = "press ❎ or 🅾️ to start",
  game_over_message = "game over",

  start = function(this)
    this.started = true
    this.grav = 0.1
    player.dx = game.scroll_speed
    del(platforms, start_platform)

    -- create enemies
    for i = 0,7 do
      e = enemy:new()
      e:init()
      add(enemies, e)
    end
  end,

  lose = function(this, animate)
    if(animate) then
      player:stop()
      player.invincible = nil
      player.visible = true

      player.game_over = cocreate(function()
        delay(30)
        player.ddy = -3
        yield()
        player.ddy = game.grav
      end)
    end

    this.ended = true 
  end,
}

function _init()
  -- change pallete for colour 0
  pal(0,129,1)

  -- disable btnp repeats
  poke(0X5F5C, 255)

  -- place player
  player.x = max_x / 2 - player.width / 2
  player.y = max_y / 2

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
  start_platform = platform:new()
  start_platform.x = max_x / 2 - start_platform.width / 2
  start_platform.y = max_y / 2 + player.height
  add(platforms, start_platform)

end

function _update()
  if not game.started then
    if (btnp(4)) then game:start() player:flap() end
    if (btnp(5)) then game:start() player:flap() end
  elseif not game.ended then
    game.timer += 1 
    game.score += 1 / 30
    
    if(flr(game.timer) % 25 == 0 and flr(rnd(3)) == 1) then
      b = balloon:new()
      b.dx = game.scroll_speed
      b:init()
      add(balloons, b)
    end

    if (btn(4)) then 
      if(player.flying) then
        coresume(player.flying)
      else
        player:fly()
      end
    else
      player.flying = nil
    end
    if (btnp(5)) then player:flap()  end
    if (btn(0)) then player:move_left() end
    if (btn(1)) then player:move_right() end

    for s in all(stars) do
      s:update()
    end

    for e in all(enemies) do
      e:update()
      if(not player.invincible and player:collide(e)) then
        shake_intensity += shake_control
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

      -- delete balloon on touch of walls
      if(b.x + b.width < min_x) then 
        del(balloons, b)
      end
    end

    player:update()

    -- lose if touch floor
    if(player.y >= max_y) then
      game:lose(false)
    end

    if(player.lives <= 0) then
      game:lose(true)
      return
    end

    player.ddy = game.grav

    --run shake when intensity high
    if shake_intensity > 0 then shake() end

  elseif game.ended then

    if player.game_over and costatus(player.game_over) != 'dead' then
      coresume(player.game_over)
    else
      player.game_over = nil
    end

    player:update()

    if(player.y >= max_y) then
      game.game_over = true
    end

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

  if not game.started then
    print(game.start_message, max_x / 2 - #game.start_message * 2, 3 * max_y / 4, 7)
  end

  if game.game_over then
    print(game.game_over_message, max_x / 2 - #game.game_over_message * 2, max_y / 2, 7)
  end
end
