all: image

image:
	docker build -t nlmacamp/check_mk:1.4.0p13 -t nlmacamp/check_mk:latest .

cleanup:
	-docker rmi nlmacamp/check_mk:latest
	-docker rmi nlmacamp/check_mk:1.4.0p13

