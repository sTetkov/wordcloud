// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import point;
import rectangle;
import boundingbox;
import image;
import arguments;
import parse;
import word;
import position;
import fontsize;

import std.stdio;
import std.file;

version(unittest)
{
	void main() {}
}
else
{
	int main(string args[])
	{
		// get program arguments
		try WordcloudArguments arguments = WordcloudArguments(args);
		catch(ArgumentException e)
		{
			stderr.writeln(e.msg);
			WordcloudArguments.printUsage();
			return 1;
		}

		// open file and parse input
		auto input = stdin;
		//...

		Word[] words;
		//...

		// scale font sizes
		//...

		// get minimal bounding rectangles for words
		//auto rectangles = ...

		//...

		// sort according to frequency
		//...

		// position rectangles
		//...

		// moves rectangles such that no rectangles upper left has a negative
		// coordinate
		//...

		// get the needed image dimension
		//...

		// draw image and write out image file
		//...

		return 0;
	}
}
