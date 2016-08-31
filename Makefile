VERSION ?= $(shell date "+%Y-%m-%d")

default: ca-bundle.crt-dockerized image

update-mk-ca-bundle.pl:
	@echo "WARNING! This operation is potentially dangerous. You should manually check the source code of the downloaded file to prevent unnecessary complications."
	@echo "To continue please type the word 'CONTINUE' (in uppercase):"
	@read ans && test "$$ans" == "CONTINUE" || ( echo "Exiting." ; exit 1 )
	curl -LSs https://raw.githubusercontent.com/curl/curl/master/lib/mk-ca-bundle.pl -o mk-ca-bundle.pl

ca-bundle.crt:
	perl mk-ca-bundle.pl
	make clean-leftovers

ca-bundle.crt-dockerized:
	docker run -it --rm -v $(shell pwd):/build alpine:latest sh -c 'apk update && apk add --no-cache make perl-libwww perl-lwp-protocol-https && cd /build && make ca-bundle.crt'

image:
	docker build -t ca-scratch .

push:
	docker tag ca-scratch quay.io/typeform/ca-scratch:$(VERSION)
	docker push quay.io/typeform/ca-scratch:$(VERSION)
	test "$(VERSION)" != "dev" && ( \
		docker tag ca-scratch quay.io/typeform/ca-scratch:latest \
		docker push quay.io/typeform/ca-scratch:latest \
	)

clean-leftovers:
	-rm -f certdata.txt

clean: clean-leftovers
	-rm -f ca-bundle.crt
	-docker rmi -f ca-scratch
	
