import core.stdc.stdio;

extern (C)
nothrow
{
enum
{
	gdFTEX_LINESPACE = 1,
	gdFTEX_CHARMAP = 2,
	gdFTEX_RESOLUTION = 4,
	gdFTEX_DISABLE_KERNING = 8,
	gdFTEX_XSHOW = 16,
	gdFTEX_FONTPATHNAME = 32,
	gdFTEX_FONTCONFIG = 64,
	gdFTEX_RETURNFONTPATHNAME = 128,
	gdFTEX_Unicode = 0,
	gdFTEX_Shift_JIS = 1,
	gdFTEX_Big5 = 2,
	gdFTEX_Adobe_Custom = 3,
	gdMaxColors = 256
}

struct gdIOCtx
{
	int function(gdIOCtx*) getC;
	int function(gdIOCtx*, void*, int) getBuf;
	void function(gdIOCtx*, int) putC;
	int function(gdIOCtx*, const(void)*, int) putBuf;
	int function(gdIOCtx*, const int) seek;
	long function(gdIOCtx*) tell;
	void function(gdIOCtx*) gd_free;
}
alias gdIOCtx* gdIOCtxPtr;

void Putword(int w, gdIOCtx* ctx);
void Putchar(int c, gdIOCtx* ctx);
void gdPutC(const(ubyte) c, gdIOCtx* ctx);
int gdPutBuf(const(void)*, int, gdIOCtx*);
void gdPutWord(int w, gdIOCtx* ctx);
void gdPutInt(int w, gdIOCtx* ctx);
int gdGetC(gdIOCtx* ctx);
int gdGetBuf(void*, int, gdIOCtx*);
int gdGetByte(int* result, gdIOCtx* ctx);
int gdGetWord(int* result, gdIOCtx* ctx);
int gdGetInt(int* result, gdIOCtx* ctx);
int gdSeek(gdIOCtx* ctx, const(int) offset);
long gdTell(gdIOCtx* ctx);
int gdAlphaBlend(int dest, int src);

struct gdImage
{
	ubyte** pixels;
	int sx;
	int sy;
	int colorsTotal;
	int red[gdMaxColors];
	int green[gdMaxColors];
	int blue[gdMaxColors];
	int open[gdMaxColors];
	int transparent;
	int* polyInts;
	int polyAllocated;
	gdImage* brush;
	gdImage* tile;
	int brushColorMap[gdMaxColors];
	int tileColorMap[gdMaxColors];
	int styleLength;
	int stylePos;
	int* style;
	int interlace;
	int thick;
	int alpha[gdMaxColors];
	int trueColor;
	int** tpixels;
	int alphaBlendingFlag;
	int saveAlphaFlag;
	int AA;
	int AA_color;
	int AA_dont_blend;
	int cx1;
	int cy1;
	int cx2;
	int cy2;
}
alias gdImage* gdImagePtr;

struct gdFont
{
	int nchars;
	int offset;
	int w;
	int h;
	char* data;
}
alias gdFont* gdFontPtr;

gdImagePtr gdImageCreate(int sx, int sy);
gdImagePtr gdImageCreateTrueColor(int sx, int sy);
gdImagePtr gdImageCreateFromPng(FILE* fd);
gdImagePtr gdImageCreateFromPngCtx(gdIOCtxPtr inPtr);
gdImagePtr gdImageCreateFromPngPtr(int size, void* data);
gdImagePtr gdImageCreateFromGif(FILE* fd);
gdImagePtr gdImageCreateFromGifCtx(gdIOCtxPtr inPtr);
gdImagePtr gdImageCreateFromGifPtr(int size, void* data);
gdImagePtr gdImageCreateFromWBMP(FILE* inFile);
gdImagePtr gdImageCreateFromWBMPCtx(gdIOCtx* infile);
gdImagePtr gdImageCreateFromWBMPPtr(int size, void* data);
gdImagePtr gdImageCreateFromJpeg(FILE* infile);
gdImagePtr gdImageCreateFromJpegCtx(gdIOCtx* infile);
gdImagePtr gdImageCreateFromJpegPtr(int size, void* data);

struct gdSource
{
	int function(void* context, char* buffer, int len) source;
	void* context;
}
alias gdSource* gdSourcePtr;

gdImagePtr gdImageCreateFromPngSource(gdSourcePtr inPtr);
gdImagePtr gdImageCreateFromGd(FILE* inFile);
gdImagePtr gdImageCreateFromGdCtx(gdIOCtxPtr inPtr);
gdImagePtr gdImageCreateFromGdPtr(int size, void* data);
gdImagePtr gdImageCreateFromGd2(FILE* inFile);
gdImagePtr gdImageCreateFromGd2Ctx(gdIOCtxPtr inPtr);
gdImagePtr gdImageCreateFromGd2Ptr(int size, void* data);
gdImagePtr gdImageCreateFromGd2Part(FILE* inFile, int srcx, int srcy, int w, int h);
gdImagePtr gdImageCreateFromGd2PartCtx(gdIOCtxPtr inPtr, int srcx, int srcy, int w, int h);
gdImagePtr gdImageCreateFromGd2PartPtr(int size, void* data, int srcx, int srcy, int w, int h);
gdImagePtr gdImageCreateFromXbm(FILE* inFile);
gdImagePtr gdImageCreateFromXpm(const(char)* filename);
void gdImageDestroy(gdImagePtr im);
void gdImageSetPixel(gdImagePtr im, int x, int y, int color);
int gdImageGetPixel(gdImagePtr im, int x, int y);
int gdImageGetTrueColorPixel(gdImagePtr im, int x, int y);
void gdImageAABlend(gdImagePtr im);
void gdImageLine(gdImagePtr im, int x1, int y1, int x2, int y2, int color);
void gdImageDashedLine(gdImagePtr im, int x1, int y1, int x2, int y2, int color);
void gdImageRectangle(gdImagePtr im, int x1, int y1, int x2, int y2, int color);
void gdImageFilledRectangle(gdImagePtr im, int x1, int y1, int x2, int y2, int color);
void gdImageSetClip(gdImagePtr im, int x1, int y1, int x2, int y2);
void gdImageGetClip(gdImagePtr im, int* x1P, int* y1P, int* x2P, int* y2P);
int gdImageBoundsSafe(gdImagePtr im, int x, int y);
void gdImageChar(gdImagePtr im, gdFontPtr f, int x, int y, int c, int color);
void gdImageCharUp(gdImagePtr im, gdFontPtr f, int x, int y, int c, int color);
void gdImageString(gdImagePtr im, gdFontPtr f, int x, int y, ubyte* s, int color);
void gdImageStringUp(gdImagePtr im, gdFontPtr f, int x, int y, ubyte* s, int color);
void gdImageString16(gdImagePtr im, gdFontPtr f, int x, int y, ushort* s, int color);
void gdImageStringUp16(gdImagePtr im, gdFontPtr f, int x, int y, ushort* s, int color);
int gdFontCacheSetup();
void gdFontCacheShutdown();
void gdFreeFontCache();
char* gdImageStringTTF(gdImage* im, int* brect, int fg, const(char)* fontlist, double ptsize, double angle, int x, int y, const(char)* string);
char* gdImageStringFT(gdImage* im, int* brect, int fg, const(char)* fontlist, double ptsize, double angle, int x, int y, const(char)* string);

struct gdFTStringExtra
{
	int flags;
	double linespacing;
	int charmap;
	int hdpi;
	int vdpi;
	char* xshow;
	char* fontpath;
}
alias gdFTStringExtra* gdFTStringExtraPtr;

int gdFTUseFontConfig(int flag);
char* gdImageStringFTEx(gdImage* im, int* brect, int fg, const(char)* fontlist, double ptsize, double angle, int x, int y, const(char)* string, gdFTStringExtraPtr strex);

struct gdPoint
{
	int x, y;
}
alias gdPoint* gdPointPtr;

void gdImagePolygon(gdImagePtr im, gdPointPtr p, int n, int c);
void gdImageOpenPolygon(gdImagePtr im, gdPointPtr p, int n, int c);
void gdImageFilledPolygon(gdImagePtr im, gdPointPtr p, int n, int c);
int gdImageColorAllocate(gdImagePtr im, int r, int g, int b);
int gdImageColorAllocateAlpha(gdImagePtr im, int r, int g, int b, int a);
int gdImageColorClosest(gdImagePtr im, int r, int g, int b);
int gdImageColorClosestAlpha(gdImagePtr im, int r, int g, int b, int a);
int gdImageColorClosestHWB(gdImagePtr im, int r, int g, int b);
int gdImageColorExact(gdImagePtr im, int r, int g, int b);
int gdImageColorExactAlpha(gdImagePtr im, int r, int g, int b, int a);
int gdImageColorResolve(gdImagePtr im, int r, int g, int b);
int gdImageColorResolveAlpha(gdImagePtr im, int r, int g, int b, int a);
void gdImageColorDeallocate(gdImagePtr im, int color);
gdImagePtr gdImageCreatePaletteFromTrueColor(gdImagePtr im, int ditherFlag, int colorsWanted);
void gdImageTrueColorToPalette(gdImagePtr im, int ditherFlag, int colorsWanted);
void gdImageColorTransparent(gdImagePtr im, int color);
void gdImagePaletteCopy(gdImagePtr dst, gdImagePtr src);
void gdImageGif(gdImagePtr im, FILE* outFile);
void gdImagePng(gdImagePtr im, FILE* outFile);
void gdImagePngCtx(gdImagePtr im, gdIOCtx* outPtr);
void gdImageGifCtx(gdImagePtr im, gdIOCtx* outPtr);
void gdImagePngEx(gdImagePtr im, FILE* outFile, int level);
void gdImagePngCtxEx(gdImagePtr im, gdIOCtx* outFile, int level);
void gdImageWBMP(gdImagePtr image, int fg, FILE* outFile);
void gdImageWBMPCtx(gdImagePtr image, int fg, gdIOCtx* outPtr);
void gdFree(void* m);
void* gdImageWBMPPtr(gdImagePtr im, int* size, int fg);
void gdImageJpeg(gdImagePtr im, FILE* outFile, int quality);
void gdImageJpegCtx(gdImagePtr im, gdIOCtx* outPtr, int quality);
void* gdImageJpegPtr(gdImagePtr im, int* size, int quality);

enum
{
	gdDisposalUnknown,
	gdDisposalNone,
	gdDisposalRestoreBackground,
	gdDisposalRestorePrevious
};

void gdImageGifAnimBegin(gdImagePtr im, FILE* outFile, int GlobalCM, int Loops);
void gdImageGifAnimAdd(gdImagePtr im, FILE* outFile, int LocalCM, int LeftOfs, int TopOfs, int Delay, int Disposal, gdImagePtr previm);
void gdImageGifAnimEnd(FILE* outFile);
void gdImageGifAnimBeginCtx(gdImagePtr im, gdIOCtx* outPtr, int GlobalCM, int Loops);
void gdImageGifAnimAddCtx(gdImagePtr im, gdIOCtx* outPtr, int LocalCM, int LeftOfs, int TopOfs, int Delay, int Disposal, gdImagePtr previm);
void gdImageGifAnimEndCtx(gdIOCtx* outPtr);
void* gdImageGifAnimBeginPtr(gdImagePtr im, int* size, int GlobalCM, int Loops);
void* gdImageGifAnimAddPtr(gdImagePtr im, int* size, int LocalCM, int LeftOfs, int TopOfs, int Delay, int Disposal, gdImagePtr previm);
void* gdImageGifAnimEndPtr(int* size);

struct gdSink
{
	int function(void* context, const(char)* buffer, int len) sink;
	void* context;
}
alias gdSink* gdSinkPtr;

void gdImagePngToSink(gdImagePtr im, gdSinkPtr outPtr);
void gdImageGd(gdImagePtr im, FILE* outFile);
void gdImageGd2(gdImagePtr im, FILE* outFile, int cs, int fmt);
void* gdImageGifPtr(gdImagePtr im, int* size);
void* gdImagePngPtr(gdImagePtr im, int* size);
void* gdImagePngPtrEx(gdImagePtr im, int* size, int level);
void* gdImageGdPtr(gdImagePtr im, int* size);
void* gdImageGd2Ptr(gdImagePtr im, int cs, int fmt, int* size);
void gdImageEllipse(gdImagePtr im, int cx, int cy, int w, int h, int color);
void gdImageFilledArc(gdImagePtr im, int cx, int cy, int w, int h, int s, int e, int color, int style);
void gdImageArc(gdImagePtr im, int cx, int cy, int w, int h, int s, int e, int color);
void gdImageEllipse(gdImagePtr im, int cx, int cy, int w, int h, int color);
void gdImageFilledEllipse(gdImagePtr im, int cx, int cy, int w, int h, int color);
void gdImageFillToBorder(gdImagePtr im, int x, int y, int border, int color);
void gdImageFill(gdImagePtr im, int x, int y, int color);
void gdImageCopy(gdImagePtr dst, gdImagePtr src, int dstX, int dstY, int srcX, int srcY, int w, int h);
void gdImageCopyMerge(gdImagePtr dst, gdImagePtr src, int dstX, int dstY, int srcX, int srcY, int w, int h, int pct);
void gdImageCopyMergeGray(gdImagePtr dst, gdImagePtr src, int dstX, int dstY, int srcX, int srcY, int w, int h, int pct);
void gdImageCopyResized(gdImagePtr dst, gdImagePtr src, int dstX, int dstY, int srcX, int srcY, int dstW, int dstH, int srcW, int srcH);
void gdImageCopyResampled(gdImagePtr dst, gdImagePtr src, int dstX, int dstY, int srcX, int srcY, int dstW, int dstH, int srcW, int srcH);
void gdImageCopyRotated(gdImagePtr dst, gdImagePtr src, double dstX, double dstY, int srcX, int srcY, int srcWidth, int srcHeight, int angle);
void gdImageSetBrush(gdImagePtr im, gdImagePtr brush);
void gdImageSetTile(gdImagePtr im, gdImagePtr tile);
void gdImageSetAntiAliased(gdImagePtr im, int c);
void gdImageSetAntiAliasedDontBlend(gdImagePtr im, int c, int dont_blend);
void gdImageSetStyle(gdImagePtr im, int* style, int noOfPixels);
void gdImageSetThickness(gdImagePtr im, int thickness);
void gdImageInterlace(gdImagePtr im, int interlaceArg);
void gdImageAlphaBlending(gdImagePtr im, int alphaBlendingArg);
void gdImageSaveAlpha(gdImagePtr im, int saveAlphaArg);
gdIOCtx* gdNewFileCtx(FILE*);
gdIOCtx* gdNewDynamicCtx(int size, void* data);
gdIOCtx* gdNewDynamicCtxEx(int size, void* data, int freeFlag);
gdIOCtx* gdNewSSCtx(gdSourcePtr inPtr, gdSinkPtr outPtr);
void* gdDPExtractData(gdIOCtx* ctx, int* size);
int gdImageCompare(gdImagePtr im1, gdImagePtr im2);
gdImagePtr gdImageSquareToCircle(gdImagePtr im, int radius);
char* gdImageStringFTCircle(gdImagePtr im, int cx, int cy, double radius, double textRadius, double fillPortion, const(char)* font, double points, const(char)* top, const(char)* bottom, int fgcolor);
void gdImageSharpen(gdImagePtr im, int pct);
}
