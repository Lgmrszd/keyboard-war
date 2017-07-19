local newFont = love.graphics.newFont

local art = newFont("fonts/NotoSansCJK-Regular.ttc", 10)
art:setFallbacks(newFont("fonts/NotoSansKannada-Regular.ttf", 10),
                 newFont("fonts/NotoSansGeorgian-Regular.ttf", 10))

local art_big = newFont("fonts/NotoSansCJK-Regular.ttc", 20)
art_big:setFallbacks(newFont("fonts/NotoSansKannada-Regular.ttf", 20),
                     newFont("fonts/NotoSansGeorgian-Regular.ttf", 20))

local menu = love.graphics.newFont(15)

return {
  art = art,
  art_big = art_big,
  menu = menu,
}
