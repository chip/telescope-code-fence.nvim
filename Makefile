.PHONY: install dev test

install:
	luarocks --lua-dir=/usr/local/opt/lua@5.1 --lua-version=5.1 --local install lunamark
# TODO necessary now that plenary.test_harness is used?
dev:
	luarocks --lua-dir=/usr/local/opt/lua@5.1 --lua-version=5.1 --local install copas
	luarocks --lua-dir=/usr/local/opt/lua@5.1 --lua-version=5.1 --local install lua-ev scm --server=http://luarocks.org/repositories/rocks-scm/
	luarocks --lua-dir=/usr/local/opt/lua@5.1 --lua-version=5.1 --local install moonscript
	luarocks --lua-dir=/usr/local/opt/lua@5.1 --lua-version=5.1 --local install busted

test:
	# ~/.luarocks/bin/busted lua/tests/telescope_code_fence_spec.lua
	nvim --headless -c "PlenaryBustedDirectory lua/tests/"
