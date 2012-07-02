// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import gd;
import point;
import rectangle;
import boundingbox;

import std.exception;
import std.conv;
import std.string;
import std.c.stdio;

/// An Image
class Image
{
	/// Constructs a white image with given width and height in pixels
	/// Params: width = is the width of the image
	///         height = is height of the image
	nothrow this(in int width, in int height)
	{
		_gdImagePtr = gdImageCreate(width, height);
		gdImageColorResolve(_gdImagePtr, white.red, white.green, white.blue);
	}

	~this()
	{
		gdImageDestroy(_gdImagePtr);
	}

	@property
	{
		/// Returns: the width of this Image
		pure nothrow int width() const { return _gdImagePtr.sx; }
		/// Returns: the height of this Image
		pure nothrow int height() const { return _gdImagePtr.sy; }
	}

	unittest
	{
		Image im = new Image(200, 100);
		assert(im.width == 200);
		assert(im.height == 100);
	}

	/// Sets the background to given Color color
	/// Params: color = is the new background color
	nothrow void setBackgroundColor(in Color color)
	{
		int gdColor = gdImageColorResolve(_gdImagePtr, color.red, color.green, color.blue);
		gdImageFilledRectangle(_gdImagePtr, 0, 0, _gdImagePtr.sx - 1, _gdImagePtr.sy - 1, gdColor);
	}

	/// Draws string str with given font and fontSizeInPt at position p
	/// Params: p = is the upper left corner of where the string str is drawn
	///         str = is the string to draw
	///         font = is the font config string used
	///         fontSizeInPt = is the font size
	void drawStringAt(in Point p, in string str, in string font, in double fontSizeInPt)
	{
		enforce(gdFTUseFontConfig(1), "fontconfig not available");
		int gdColor = gdImageColorResolve(_gdImagePtr, black.red, black.green, black.blue);
		// CAVEAT
		// GD does not draw the string's upper left at given (x,y)
		// it does draw it at the string's ground line.
		//
		// Example:
		//                 (0,-8) +---------------------+
		//                        |B          EEEEE     |
		//                        |B          E   E     |
		//                        |BBBB Y   Y EEEEE     |
		//                        |B  B  Y Y  E         |
		//                        |BBBB   Y   EEEEE     |
		//                 (0,0)  +------Y--------------+
		//                        |     Y               |
		//                        |    Y                |
		//                        +---------------------+
		// If we want to draw e.g. the word 'bye' as above, we have to draw it
		// at (0,0) (and not (0,-8)). That's why we subtract p.y - r.top, i.e.
		// in the above case 0 - (-8) = 8. Same reasoning applies to the
		// x-coordinate. This way the drawing of a string is fixed.
		Rectangle r = minimalBoundingRectangle(str, font, fontSizeInPt);
		char* error = gdImageStringFTEx(_gdImagePtr, null, gdColor,
		                                toStringz(font), fontSizeInPt,
		                                0.0, p.x - r.left, p.y - r.top,
		                                toStringz(str), null);
		enforce(!error, text("GD error: ", error));
	}

	unittest
	{
		string font = "";
		double fontSize = 30;
		string word = "dfgh";
		Rectangle boundingRectangle = minimalBoundingRectangle(word, font, fontSize);
		boundingRectangle.moveUpperLeftTo(origin);

		Image im = new Image(boundingRectangle.width, boundingRectangle.height);
		im.setBackgroundColor(red);
		im.drawStringAt(boundingRectangle.upperLeft, word, font, fontSize);
		im.writeAsPng("test.png");
	}

	/// Writes this Image as PNG file to given filename. It won't overwrite an
	/// existing unless overWrite is true.
	/// Params: filename = is the filename of the written PNG file
	/// Throws: Exception if file with filename already exists.
	void writeAsPng(in string filename)
	{
		import std.file;
		FILE* fp = enforce(std.c.stdio.fopen(std.string.toStringz(filename), "w+"));
		scope(exit) fclose(fp);
		gdImagePng(_gdImagePtr, fp);
	}

private:
	gdImagePtr _gdImagePtr;
}

enum black = Color(0, 0, 0);
enum white = Color(255, 255, 255);
enum red = Color(255, 0, 0);
enum blue = Color(0, 255, 0);
enum green = Color(0, 0, 255);

struct Color
{
	pure nothrow this(in ubyte red, in ubyte green, in ubyte blue)
	{
		this.red = red;
		this.green = green;
		this.blue = blue;
	}

	ubyte red, green, blue;
}
