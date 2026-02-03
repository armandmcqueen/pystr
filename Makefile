.PHONY: test demo

test:
	uv run --with pytest pytest test_pystr.py -v

demo:
	@./generate_demo.sh > demo.md
	@echo "Generated demo.md"
