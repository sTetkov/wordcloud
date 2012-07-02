// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import word;
import arguments;

import std.file;
import std.string;
import std.conv;
import std.exception;
debug import std.stdio;

/// Parses a file into words where a line of the file looks like
/// 'word double'
void parseInput(std.file.File file, out Word[] words)
{
	size_t lineNo = 0;
	foreach (line; file.byLine())
	{
		++lineNo;
		debug writefln("Got line '%s'", line);
		auto splittedLine = line.split();
		debug writefln("splittedLine '%s'", splittedLine);
		enforceEx!FileFormatException(splittedLine.length == 2,
		                              format("%s at line %s: got '%s' but expected '%s'.",
		                                     file.name ? file.name : "<stdin>", lineNo, line, WordcloudArguments.FILE_FORMAT));
		string word = splittedLine[0].idup;
		double frequency;
		try frequency = to!(double)(splittedLine[1]);
		catch(ConvException e)
		{
			throw new FileFormatException(format("%s at line %s: got '%s' where the second argument is no double.",
			                                     file.name ? file.name : "<stdin>", lineNo, line), e);
		}
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

class FileFormatException : Exception
{
	nothrow this(string msg, string file = __FILE__, size_t line = __LINE__)
	{
		super(msg, file, line);
	}

	nothrow this(string msg, Throwable next = null, string file = __FILE__, size_t line = __LINE__)
	{
		super(msg, file, line, next);
	}
}
