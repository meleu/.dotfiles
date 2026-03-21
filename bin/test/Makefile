.PHONY: test

test:
	@if command -v parallel >/dev/null 2>&1; then \
		bats --jobs $$(nproc) .; \
	else \
		bats .; \
	fi
