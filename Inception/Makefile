# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: hgandar <hgandar@student.42lausanne.ch>    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/09/25 13:46:47 by hgandar           #+#    #+#              #
#    Updated: 2024/09/25 14:06:06 by hgandar          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all: up

up:
	docker compose -f ./srcs/docker-compose.yml up -d --build

prepare:
	@mkdir -p /home/user/data/mariadb /home/user/data/wordpress
	sudo chown -R user:user /home/user/data/mariadb
	sudo chmod -R 777 /home/user/data/mariadb
	sudo chown -R user:user /home/user/data/wordpress
	sudo chmod -R 777 /home/user/data/wordpress

build: prepare
	docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	docker compose -f ./srcs/docker-compose.yml down

downv:
	docker compose -f ./srcs/docker-compose.yml down -v

restart:
	docker compose -f ./srcs/docker-compose.yml down && docker-compose -f ./srcs/docker-compose.yml up -d

stop: 
	@docker compose -f ./srcs/docker-compose.yml stop

start: 
	@docker compose -f ./srcs/docker-compose.yml start

status: 
	@docker ps

network:
	@docker network ls

logs:
	@docker compose -f ./srcs/docker-compose.yml logs

clean:
	@docker system prune -af --volumes
	sudo rm -rf /home/user/data/mariadb
	sudo rm -rf /home/user/data/wordpress

