// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

extern (C)
{
struct FcObjectSet
{
	int nobject;
	int sobject;
	const(char)**objects;
}

struct FcFontSet
{
	int nfont;
	int sfont;
	FcPattern** fonts;
}

struct FcPattern;
struct FcConfig;

FcPattern* FcPatternCreate();
void FcPatternDestroy(FcPattern *p);

FcObjectSet* FcObjectSetCreate();
void FcObjectSetDestroy(FcObjectSet *os);

FcFontSet* FcFontList(FcConfig *config, FcPattern *p, FcObjectSet *os);
void FcFontSetDestroy(FcFontSet *s);

FcObjectSet* FcObjectSetBuild(const char *first, ...);

alias char FcChar8;

FcChar8* FcPatternFormat(FcPattern *pat, const FcChar8 *format);

enum FC_FAMILY = "family";
enum FC_STYLE  = "style";
enum FC_FILE   = "file";
}
