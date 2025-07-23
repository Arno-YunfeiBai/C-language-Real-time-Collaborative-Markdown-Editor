CC      := gcc
CFLAGS  := -std=c11 -Wall -Wextra -Werror -fsanitize=address -g -D_POSIX_C_SOURCE=200809L
LDFLAGS := -lpthread

SRC_DIR := source
OBJ     := server.o client.o markdown.o log.o server_helpers.o client_helpers.o

all: server client

server: server.o markdown.o log.o server_helpers.o
	$(CC) $(CFLAGS) -o server \
	    server.o markdown.o log.o server_helpers.o

client: client.o markdown.o log.o client_helpers.o
	$(CC) $(CFLAGS) -o client \
	    client.o markdown.o log.o client_helpers.o

server.o: $(SRC_DIR)/server.c
	$(CC) $(CFLAGS) -c $< -o $@

client.o: $(SRC_DIR)/client.c
	$(CC) $(CFLAGS) -c $< -o $@

markdown.o: $(SRC_DIR)/markdown.c
	$(CC) $(CFLAGS) -c $< -o $@

log.o: $(SRC_DIR)/log.c
	$(CC) $(CFLAGS) -c $< -o $@

server_helpers.o: $(SRC_DIR)/server_helpers.c
	$(CC) $(CFLAGS) -c $< -o $@

client_helpers.o: $(SRC_DIR)/client_helpers.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f *.o server client