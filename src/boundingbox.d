// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import gd;
import rectangle;
import point;
import word;

import std.exception;
import std.string;
import std.conv;

/// Returns the minimal bounding access parallel rectangle of a given word using
/// the font and font size. If font is not available the default font is used.
/// Returns: The minimal bounding rectangle for the given string
/// Params: word = is the word
///         font = font config string
///         fontSizeInPt = font size in pt
///
/// Bug: There is some limit on fontSizeInPt. The resulting rectangle's
///      dimension wrap at some points (dependent on the word and the font)
Rectangle minimalBoundingRectangle(string word, string font, double fontSizeInPt)
{
	enforce(gdFTUseFontConfig(1), "fontconfig not available");
	int boundingRectangle[8];
	char* error = gdImageStringFTEx(null, boundingRectangle.ptr, 0,
	                                toStringz(font), fontSizeInPt,
	                                0.0, 0, 0, toStringz(word), null);
	enforce(!error, text("GD error: ", error));
	Rectangle r = Rectangle(UpperLeft(boundingRectangle[6], boundingRectangle[7]),
	                        LowerRight(boundingRectangle[2], boundingRectangle[3]));
	// TODO
	// use all coordinates of the result
	// 0,1 lower left corner
	// 2,3 lower right corner
	// 4,5 upper right corner
	// 6,7 upper left corner

	// but it seems that they are redundant
	// because this holds
	assert(boundingRectangle[1] == boundingRectangle[3]);
	assert(boundingRectangle[2] == boundingRectangle[4]);
	assert(boundingRectangle[5] == boundingRectangle[7]);
	assert(boundingRectangle[0] == boundingRectangle[6]);

	return r;
}

string[] availableFonts()
{
	import fontconfig;
	import std.array;

	auto fonts = appender!(string[])();

	FcObjectSet *os;
	FcFontSet *fs;
	FcPattern *pat;

	pat = FcPatternCreate();
	scope(exit) if (pat) FcPatternDestroy(pat);
	os = FcObjectSetBuild(toStringz(FC_FAMILY), toStringz(FC_STYLE), null);
	scope(exit) if (os) FcObjectSetDestroy(os);

	fs = FcFontList(null, pat, os);
	scope(exit) if (fs) FcFontSetDestroy(fs);

	foreach (i; 0 .. fs.nfont)
	{
		FcChar8 *s = FcPatternFormat(fs.fonts[i], toStringz("%{=fclist}"));

		if (s)
		{
			fonts.put(to!string(s));
			import core.stdc.stdlib;
			free(s);
		}
	}

	return fonts.data;
}

unittest
{
	auto emptyWord = "";
	auto wordTest = "test";
	auto wordFoobar = "foobar";
	Rectangle r;

	r = minimalBoundingRectangle(emptyWord, "", 10);
	assert(r.width == 2, to!string(r.width));
	assert(r.height == 2, to!string(r.height));

	r = minimalBoundingRectangle(wordTest, "", 10);
	assert(r.width == 28);
	assert(r.height == 12);

	r = minimalBoundingRectangle(wordTest, "", 14);
	assert(r.width == 38);
	assert(r.height == 15);

	r = minimalBoundingRectangle(wordFoobar, "", 18);
	assert(r.width == 79);
	assert(r.height == 20);

	r = minimalBoundingRectangle(wordFoobar, "", 0);
	assert(r.width == 6);
	assert(r.height == 3);

	r = minimalBoundingRectangle(wordFoobar, "", -1);
	assert(r.width == 6);
	assert(r.height == 3);

	// BUG
	r = minimalBoundingRectangle(".", "", 15728);
	assert(r.width == 4426, to!string(r.width));
	r = minimalBoundingRectangle(".", "", 15728 + 1);
	assert(r.width == 2, to!string(r.width));
	r = minimalBoundingRectangle(".", "", 0);
	assert(r.width == 2, to!string(r.width));
	// TODO
	// what about negative sizes?
	r = minimalBoundingRectangle(".", "", -1);
	assert(r.width == 2, to!string(r.width));

	// test different fonts if available
	auto fonts = sort(availableFonts());
	auto font = "Nimbus Sans L:style=Bold";
	if (fonts.contains(font))
	{
		r = minimalBoundingRectangle(wordFoobar, font, 10);
		assert(r.width == 43, to!string(r.width));
		assert(r.height == 12, to!string(r.height));
	}

	font = "URW Bookman L:style=Demi Bold";
	if (fonts.contains(font))
	{
		r = minimalBoundingRectangle(wordFoobar, font, 10);
		//assert(r.width == 45, to!string(r.width));
		assert(r.height == 12, to!string(r.height));
	}

	font = "Standard Symbols L:style=Regular";
	if (fonts.contains(font))
	{
		r = minimalBoundingRectangle(wordFoobar, font, 10);
		assert(r.width == 21, to!string(r.width));
		assert(r.height == 2, to!string(r.height));
	}

	font = "DejaVu Sans:style=Bold";
	if (fonts.contains(font))
	{
		r = minimalBoundingRectangle(wordFoobar, font, 10);
		assert(r.width == 52, to!string(r.width));
		assert(r.height == 12, to!string(r.height));
	}

	font = "Dingbats:style=Regular";
	if (fonts.contains(font))
	{
		r = minimalBoundingRectangle(wordFoobar, font, 10);
		assert(r.width == 25, to!string(r.width));
		assert(r.height == 2, to!string(r.height));
	}

	font = "URW Palladio L:style=Roman";
	if (fonts.contains(font))
	{
		r = minimalBoundingRectangle(wordFoobar, font, 10);
		assert(r.width == 40, to!string(r.width));
		assert(r.height == 12, to!string(r.height));
	}
}

/// Compute the minimal bounding rectangle for each given word. Each rectangle's
/// upper left is at origin.
Rectangle[] boundingRectangles(in Word[] words, in string font)
{
	Rectangle[] rectangles;
	foreach (word; words)
	{
		auto r = minimalBoundingRectangle(word.word, font, word.frequency);
		r.moveUpperLeftTo(origin);
		rectangles ~= r;
	}

	return rectangles;
}

unittest
{
	Word[] words = [
	    Word("test", 10),
	    Word("foobar", 18),
	];
	auto rectangles = boundingRectangles(words, "");
	Rectangle[] refRectangles = [
	    Rectangle(UpperLeft(0,0), LowerRight(28,12)),
	    Rectangle(UpperLeft(0,0), LowerRight(79,20))
	];
	assert(refRectangles == rectangles, to!string(rectangles));

	words = [
	    Word(".", 10),
	    Word(".", 18),
	];
	rectangles = boundingRectangles(words, "");
	refRectangles = [
	    Rectangle(UpperLeft(0,0), LowerRight(5,4)),
	    Rectangle(UpperLeft(0,0), LowerRight(8,5))
	];
	assert(refRectangles == rectangles, to!string(rectangles));
}


import std.algorithm;

/// compute Point (x,y) such that x and y are the smallest coordinates of the
/// upper left of all rectangles
/// i.e. Returns: the upper left of the minimal bounding rectangle of the given rectangles
Point boundingUpperLeft(Rectangle[] rectangles)
{
	auto min = reduce!((a, b) => Point(min(a.x, b.left), min(a.y, b.top)))
	               (Point.max, rectangles);
	return min;
}

unittest
{
	Rectangle[] rectangles;
	assert(Point.max == boundingUpperLeft(rectangles));

	rectangles ~= [
	    Rectangle(UpperLeft(0,0), LowerRight(1,1)),
	    Rectangle(UpperLeft(2,3), LowerRight(3,100)),
	];

	assert(Point(0,0) == boundingUpperLeft(rectangles));
	assert(Point(-1,0) == boundingUpperLeft(rectangles ~ Rectangle(UpperLeft(-1, 0), LowerRight(0,1))));
	assert(Point(0,-1) == boundingUpperLeft(rectangles ~ Rectangle(UpperLeft(0, -1), LowerRight(1,0))));
}

Point boundingLowerRight(Rectangle[] rectangles)
{
	auto max = reduce!((a, b) => Point(max(a.x, b.right), max(a.y, b.bottom)))
	               (Point.min, rectangles);
	return max;
}

unittest
{
	Rectangle[] rectangles;
	assert(Point.max == boundingUpperLeft(rectangles));

	rectangles ~= [
	    Rectangle(UpperLeft(-1,-1), LowerRight(0,0)),
	    Rectangle(UpperLeft(-1,-1), LowerRight(1,1)),
	];

	assert(Point(1,1) == boundingLowerRight(rectangles));
	assert(Point(2,1) == boundingLowerRight(rectangles ~ Rectangle(UpperLeft(-1, -1), LowerRight(2,1))));
	assert(Point(1,2) == boundingLowerRight(rectangles ~ Rectangle(UpperLeft(-1, -1), LowerRight(1,2))));
}
