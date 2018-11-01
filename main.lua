debug = true
player = { x = 200, y = 510, speed = 450, img = nil }
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax
bulletImg = nil
bullets = {}
createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
enemyImg = nil 
enemies = {}
isAlive = true
score = 0
time = love.timer.getTime( )



function love.load(arg)
player.img = love.graphics.newImage('assets/plane.png')
bulletImg = love.graphics.newImage('assets/bullet.png')
enemyImg = love.graphics.newImage('assets/enemy.png')
background = love.graphics.newImage("assets/background.jpg")
   wwinitTime = love.timer.getTime()
   displayString = true
end

function love.update(dt)  
if love.keyboard.isDown('escape') then
love.event.push('quit')
end

canShootTimer = canShootTimer - (1 * dt)
if canShootTimer < 0 then
canShoot = true
end



for i, bullet in ipairs(bullets) do
bullet.y = bullet.y - (250 * dt)
if bullet.y < 0 then -- remove bullet when they pass off the screen
table.remove(bullets, i)
  end
end


-- keyboard setings------
if love.keyboard.isDown('space') and canShoot then
newBullet = {x = player.x + (player.img:getWidth()/2), y = player.y,img = bulletImg}
table.insert(bullets, newBullet)
canShoot = false
canShootTimer = canShootTimerMax
end

if love.keyboard.isDown('left', 'a') then
  
if player.x > 0 then
player.x = player.x - (player.speed*dt)
end
elseif love.keyboard.isDown('right','d') then

if love.keyboard.isDown('up', 'w') then
	if player.y > (love.graphics.getHeight() / 2) then
		player.y = player.y - (player.speed*dt)
	end
elseif love.keyboard.isDown('down', 's') then
	if player.y < (love.graphics.getHeight() - 55) then
		player.y = player.y + (player.speed*dt)
	end
end
---------------------------


if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
player.x = player.x + (player.speed*dt)
    end
  end
  -- Time out enemy creation
createEnemyTimer = createEnemyTimer - (1 * dt)
if createEnemyTimer < 0 then
	createEnemyTimer = createEnemyTimerMax

	-- Create an enemy
	randomNumber = math.random(10, love.graphics.getWidth() - 10)
	newEnemy = { x = randomNumber, y = -10, img = enemyImg }
	table.insert(enemies, newEnemy)
end
for i, enemy in ipairs(enemies) do
	enemy.y = enemy.y + (200 * dt)

	if enemy.y > 850 then -- remove enemies when they pass off the screen
		table.remove(enemies, i)
	end
end
for i, enemy in ipairs(enemies) do
	for j, bullet in ipairs(bullets) do
		if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
			table.remove(bullets, j)
			table.remove(enemies, i)
			score = score + 420 --fore one kill you get a score of 420
		end
	end

	if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
	and isAlive then
		table.remove(enemies, i)
		isAlive = false
    end
  end
  
if not isAlive and love.keyboard.isDown('r') then
	-- remove all our bullets and enemies from screen
	bullets = {}
	enemies = {}

	-- reset timers
	canShootTimer = canShootTimerMax
	createEnemyTimer = createEnemyTimerMax

	-- move player back to default position
	player.x = 200
	player.y = 510

	-- reset our game state
	score = 0
	isAlive = true
end
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
function love.draw(dt)
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end
for i, bullet in ipairs(bullets) do
love.graphics.draw(bullet.img, bullet.x, bullet.y)
end
for i, enemy in ipairs(enemies) do
	love.graphics.draw(enemy.img, enemy.x, enemy.y)
end
if isAlive then
	love.graphics.draw(player.img, player.x, player.y)
else
	love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
end
love.graphics.setColor(255, 255, 255)
love.graphics.print("SCORE: " .. tostring(score), 340, 10)

--love.graphics.print("Timer: " .. timer .. " Sec left")
end
