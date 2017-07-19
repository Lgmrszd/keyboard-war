{
  -- debug: true
  scene_width: 600
  scene_height: 600
  panel_width: 200
  fonts: {
    art: love.graphics.newFont "fonts/NotoSansCJK-Regular.ttc", 10
    art_big: love.graphics.newFont "fonts/NotoSansCJK-Regular.ttc", 20
    menu: love.graphics.newFont 15
  }
  binds: {
    shoot: "z"
    bomb: "x"
    slowdown: {"lshift", "lctrl"}
  }
}
