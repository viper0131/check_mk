all: image

image:
	docker build -t nlmacamp/check_mk:1.2.8p25 .
