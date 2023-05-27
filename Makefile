profana-up:
	docker build . -t profana_local 
	docker run --name=profana -p 3000:3000 -p 9090:9090 -d profana_local

profana-down:
	docker stop profana 
	docker rm profana
