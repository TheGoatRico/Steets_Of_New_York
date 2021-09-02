fx_version "adamant"
game "gta5"

ui_page "html/ui.html"

client_scripts {
  "@cloud-core/locale.lua",
  "client/main.lua",
  "client/trunk.lua",
  "client/property.lua",
  "client/player.lua",
  "client/shops.lua",
  --"client/ricoshops.lua",
  "client/steal.lua",
  "client/storage.lua",
  "locales/*.lua",
  "config.lua"
}

server_scripts {
  "@mysql-async/lib/MySQL.lua",
  "@cloud-core/locale.lua",
  "server/main.lua",
  "server/storage.lua",
  "server/trunk.lua",
  "server/steal.lua",
  --"server/ricoshops.lua",
  "locales/*.lua",
  "config.lua"
}

files {
  "html/ui.html",
  "html/css/ui.css",
  "html/css/jquery-ui.css",
  "html/js/inventory.js",
  "html/js/config.js",
  -- JS LOCALES
  "html/locales/*.js",
  -- IMAGES
  "html/img/bullet.png",
  -- ICONS
  "html/img/items/*.png"
}

client_script '@Wetem_Biketricks/client/main.lua'