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
	@docker-compose -f ./srcs/docker-compose.yml up -d

down: 
	@docker-compose -f ./srcs/docker-compose.yml down

stop: 
	@docker-compose -f ./srcs/docker-compose.yml stop

start: 
	@docker-compose -f ./srcs/docker-compose.yml start

status: 
	@docker ps

network:
	@docker network ls

logs:
	@docker-compose -f ./srcs/docker-compose.yml logs

rebuild:
	@docker-compose -f ./srcs/docker-compose.yml up --build -d

clean:
	@docker system prune -af --volumes


