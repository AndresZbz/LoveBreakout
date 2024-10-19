-- global variables
screen_width = 640
screen_height = 480
game_running = false

-- paddle variables
local rectX = screen_width / 2
local rectY = 400
local rectWidth = 96
local rectHeight = 32
local speed = 300

-- ball variables
local ballx = screen_width / 2
local bally = 364
local ballw = 32
local ballh = 32
local speedx = 200
local speedy = -200

-- blocks movement
local blocks = {}
local blockw = 96
local blockh = 32

function love.load()
    love.window.setMode(screen_width, screen_height)
    love.window.setTitle("Love2D breakout")
    spawn_blocks()
end

function spawn_blocks()
    blocks = {}
    for row = 0, 4 do  
        for col = 0, 6 do 
            table.insert(blocks, {
                x = col * blockw,
                y = row * blockh,
                active = true 
            })
        end
    end

end

function love.update(dt)
    -- Paddle movement
    if love.keyboard.isDown("left") and rectX > 0 then
        rectX = rectX - speed * dt
    end

    if love.keyboard.isDown("right") and rectX < 540 then
        rectX = rectX + speed * dt
    end

    if love.keyboard.isDown("return") then
        game_running = true
    end

    -- Ball movement
    if game_running then
        ballx = ballx + speedx * dt
        bally = bally + speedy * dt
    end

    -- Collision with paddle
    if game_running and 
        ballx + ballw > rectX and 
        ballx < rectX + rectWidth and 
        bally + ballh > rectY and 
        bally < rectY + rectHeight then
        speedy = -speedy
        bally = rectY - ballh
    end
    
    -- Collision with blocks
    for i, block in ipairs(blocks) do
        if block.active and 
           ballx + ballw > block.x and 
           ballx < block.x + blockw and 
           bally + ballh > block.y and 
           bally < block.y + blockh then
            block.active = false  -- Deactivate the block
            speedy = -speedy  -- Reverse the ball's vertical direction
            break  -- Exit the loop after collision
        end
    end

    if ballx > 618 then
        speedx = -200
    elseif ballx < 0 then
        speedx = 200
    end

    if bally < 0 then
        speedy = 200
    elseif bally > screen_height then
        game_running = false
        bally = 364
        ballx = screen_width / 2
        spawn_blocks()
    end
end

function love.draw()
    if game_running then
        love.graphics.rectangle("fill", rectX, rectY, rectWidth, rectHeight)
        love.graphics.rectangle("fill", ballx, bally, ballw, ballh)

        -- Draw blocks
        for i, block in ipairs(blocks) do
            if block.active then
                love.graphics.rectangle("fill", block.x, block.y, blockw, blockh)
            end
        end
    else 
        love.graphics.print("Press enter to play", 320, 240)
    end
end