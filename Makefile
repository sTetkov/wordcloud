DC = dmd
DFLAGS = -unittest -property -w -wi -gc -Isrc
LD = dmd

SOURCES = $(wildcard src/*.d)
OBJECTS = $(patsubst %.d, %.o, $(SOURCES))
BINARY = wordcloud

SOURCES_UNCRUSITFY = $(addsuffix .uncr,$(SOURCES))
STYLE = .style.cfg

%.o: %.d
	$(DC) $(DFLAGS) -c $< -of$@

.PHONY: all
all: build

.PHONY: build
build: $(BINARY)

$(BINARY): $(OBJECTS)
	$(LD) $(LDFLAGS) $^ -of$@

.PHONY: $(SOURCES_UNCRUSITFY)
$(SOURCES_UNCRUSITFY): $(STYLE)
	uncrustify -c $(STYLE) -f $(basename $@) | diff -u $(basename $@) -

.PHONY: uncrustify
uncrustify: $(SOURCES_UNCRUSITFY) $(STYLE)

.PHONY: clean
clean:
	rm -f $(OBJECTS) $(BINARY)
