DC = dmd
DFLAGS = -property -w -wi -gc -Isrc
LD = dmd

SOURCES = $(wildcard src/*.d)
OBJECTS = $(patsubst %.d, %.o, $(SOURCES))
BINARY = wordcloud

%.o: %.d
	$(DC) $(DFLAGS) -c $< -of$@

.PHONY: all
all: build

.PHONY: build
build: $(BINARY)

$(BINARY): $(OBJECTS)
	$(LD) $(LDFLAGS) $^ -of$@

.PHONY: clean
clean:
	rm -f $(OBJECTS) $(BINARY)
