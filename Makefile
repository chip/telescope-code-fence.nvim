.PHONY: install test

install:
	luarocks --lua-dir=/usr/local/opt/lua@5.1 --lua-version=5.1 --local install lunamark

test:
	nvim --headless -c "PlenaryBustedDirectory lua/tests/"
