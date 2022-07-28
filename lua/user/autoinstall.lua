local sh = require("user.utils.sh")

local brew = sh.command("brew")
brew("install", "fs")
