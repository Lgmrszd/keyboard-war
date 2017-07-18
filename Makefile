all: run

run: moon
	love .

moon:
	moonc *.moon
	moonc */*.moon
