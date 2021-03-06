CC = gcc
CFLAGS+=-g -O0 -fPIC -Wall
LDFLAGS+=
INCDIRS+=

SOURCES=acvp.c acvp_aes.c acvp_transport.c acvp_util.c parson.c 
OBJECTS=$(SOURCES:.c=.o)

all: libacvp.a acvp_app

.PHONY: test testcpp

libacvp.a: $(OBJECTS)
	ar rcs libacvp.a $(OBJECTS)

.c.o:
	$(CC) $(INCDIRS) $(CFLAGS) -c $< -o $@

libacvp.so: $(OBJECTS)
	$(CC) $(INCDIRS) $(CFLAGS) -shared -Wl,-soname,libacvp.so.1.0.0 -o libacvp.so.1.0.0 $(OBJECTS)
	ln -fs libacvp.so.1.0.0 libacvp.so

acvp_app: app_main.c libacvp.a
	$(CC) $(INCDIRS) $(CFLAGS) -o $@ app_main.c -L. $(LDFLAGS) -lacvp -lssl -lcrypto -lcurl -ldl

clean:
	rm -f *.[ao]
	rm -f libacvp.so.1.0.0
	rm -f acvp_app
	rm -f testgcm
