package = "kauth"
version = "1.0-1"
source = {
  url = "https://kaos.engineer"
}

dependencies = {
	"lua >= 5.3",
}

local srcs = {
	"kauth.c",
}

build = {
  type = "builtin",
  modules = { 
    kauth = {
      sources = srcs,
      libraries = {"sodium"},
    },
  },
  platforms = {
		unix = { modules = { kauth = srcs } },
	},
}