// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import word;

import std.file;
import std.string;
import std.conv;
debug import std.stdio;

/// Parses a file into words where a line of the file looks like
/// 'word double'
void parseInput(std.file.File file, out Word[] words)
{
	foreach (line; file.byLine())
	{
		debug writefln("Got line '%s'", line);
		auto splittedLine = line.split();
		debug writefln("splittedLine '%s'", splittedLine);
		string word = splittedLine[0].idup;
		double frequency = to!(double)(splittedLine[1]);
		words ~= Word(word, frequency);
	}
}

version(unittest)
{
	import std.stdio;
	private string tmpTestFilename = "parse.d.unittest";
}

unittest
{
	// empty file
	std.file.write(tmpTestFilename, "");
	scope(exit) {
		assert(exists(tmpTestFilename));
		remove(tmpTestFilename);
	}
	Word[] words;
	auto file = File(tmpTestFilename, "r");
	parseInput(file, words);
	Word[] refWords;
	assert(refWords == words);
}

unittest
{
	void writeFile(in string tmpTestFilename, in Word[] words)
	{
		auto input = File(tmpTestFilename, "w");
		foreach (word; words)
		{
			input.writefln("%s %s", word.word, word.frequency);
		}
	}

	Word[] refWords = [
	    Word("simple", 102),
	    Word("correct", 36),
	    Word("efficient", 25),
	    Word("portable", 108),
	    Word("easy", 136),
	    Word("effective", 46),
	    Word("beautiful", 52),
	    Word("elegant", 35),
	    Word("bug-free", 49),
	    Word("consistent", 18),
	    Word("generic", 23)
	];

	writeFile(tmpTestFilename, refWords);
	scope(exit)
	{
		assert(exists(tmpTestFilename));
		remove(tmpTestFilename);
	}

	Word[] words;
	auto file = File(tmpTestFilename, "r");
	parseInput(file, words);
	assert(refWords == words);
}
