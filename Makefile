all: image

image:
	docker build -t nlmacamp/check_mk .
