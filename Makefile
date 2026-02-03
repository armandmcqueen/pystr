.PHONY: test

test:
	uv run --with pytest pytest tests/ -v
