# CFLAGS += -c -O2 -fPIC $$(pkg-config --cflags lua-5.3 libsodium)
# LDFLAGS += -shared -fPIC $$(pkg-config --libs libsodium lua-5.3)

all: default

kauth.so: kauth.c
	luarocks make --no-install

clean:
	rm kauth.o kauth.so

.PHONY: clean