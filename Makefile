all: image

image:
	docker build -t machiel/checkmk .
