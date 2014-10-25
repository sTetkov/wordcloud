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
import std.array : empty;

version(unittest)
{
	void main() {}
}
else
{
	//Some comment relating to the main function
	int main(string args[])
	{
		// get program arguments
		WordcloudArguments arguments;
		try arguments = WordcloudArguments(args);
		catch(ArgumentException e)
		{
			//Argument error output on std error stream 
			stderr.writeln(e.msg);
			WordcloudArguments.printUsage();
			return 1;
		}

		// open file and parse input
		auto input = stdin;
		if (arguments.inputFile)
		{
			try input = File(arguments.inputFile, "r");
			catch(Exception e)
			{
				stderr.writeln(e.msg);
				return 2;
			}
		}
		else
		{
			writeln("Reading from stdin ...");
		}

		Word[] words;
		try parseInput(input, words);
		catch(FileFormatException e)
		{
			stderr.writeln(e.msg);
			return 2;
		}

		if (words.empty)
		{
			stderr.writeln("No input is given. Skipping.");
			return 2;
		}

		// scale font sizes
		computeFontSize(words, arguments.minFontSize, arguments.maxFontSize);

		// get minimal bounding rectangles for words
		auto rectangles = boundingRectangles(words, arguments.font);
		import std.range;
		// @@@BUG@@@ 7948
		//auto wordsWithRectangles = zip(StoppingPolicy.requireSameLength, words, rectangles);
		auto wordsWithRectangles = zip(words, rectangles);

		import std.algorithm;
		// sort according to frequency
		sort!("a[0].frequency > b[0].frequency")(wordsWithRectangles);

		// position rectangles
		positionRectangles(rectangles);

		// moves rectangles such that no rectangles upper left has a negative
		// coordinate
		auto min = rectangles.boundingUpperLeft();
		foreach (ref r; rectangles) r.moveUpperLeftTo(r.upperLeft - min);
		assert(rectangles.boundingUpperLeft() == origin);

		// get the needed image dimension
		auto max = rectangles.boundingLowerRight();

		// draw image and write out image file
		Image im = new Image(max.x, max.y);
		foreach (word, fontSize, r; wordsWithRectangles)
		{
			im.drawStringAt(r.upperLeft, word, arguments.font, fontSize);
		}
		im.writeAsPng(arguments.outputFile);

		return 0;
	}
}
