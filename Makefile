run:
	gleam run -m tailwind/run
	gleam run
format:
	gleam format
install-tailwind-cli:
	gleam run -m tailwind/install
e2e-test:
	cd e2e && yarn start
docker-build:
	cd build && gleam export erlang-shipment && cd .. && docker build -t crappy-board:latest .
