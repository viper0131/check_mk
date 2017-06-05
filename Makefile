all: image

image:
	docker build -t nlmacamp/check_mk:1.4.0p1 -t nlmacamp/check_mk:latest .
