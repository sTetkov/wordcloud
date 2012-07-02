// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import std.getopt;
import std.stdio;
import std.file;
import std.string;
import std.exception;
import core.stdc.stdlib;

struct WordcloudArguments
{
	immutable double DEFAULT_MIN_FONT_SIZE = 10;
	immutable double DEFAULT_MAX_FONT_SIZE = 20;
	immutable string FILE_FORMAT = "<word> <double>";

	this(string args[])
	{
		_minFontSize = DEFAULT_MIN_FONT_SIZE;
		_maxFontSize = DEFAULT_MAX_FONT_SIZE;
		_font = "";
		bool help;
		try
		{
			getopt(args,
			       "i",         &_inputFile,
			       "f",         &_font,
			       "min",       &_minFontSize,
			       "max",       &_maxFontSize,
			       "overwrite", &_overwriteFile,
			       "help",      &help
			       );
		}
		catch(Exception e)
		{
			throw new ArgumentException(e.msg);
		}

		if (help)
		{
			printUsage();
			exit(0);
		}

		enforceEx!ArgumentException(args.length <= 2, format("Unrecognized options %s.", args[1 .. $]));
		enforceEx!ArgumentException(args.length == 2, "You have to specify an output file.");
		_outputFile = args[$ - 1];

		enforceEx!ArgumentException(overwriteFile || !exists(_outputFile),
		                            format("File '%s' already exists. Skipping. Use --overwrite.", _outputFile));
	}

	static void printUsage()
	{
		writeln("Usage: wordcloud [--i file] [--f font] [--min double] [--max double] outputFile\n"
		        "\n"
		        "Create a wordcloud containing the given words using the respective importance values.\n"
		        "\n"
		        "Options:\n"
		        "  --i file        Input file name. Defaults to stdin.\n"
		        "  --f font        Font config string, e.g. Times-12:bold or \"Monospace:matrix=1 .1 0 1\".\n"
		        "                  Run fc-list to get a list of all fontconfig fonts on your system. Defaults to \"\".\n"
		        "  --min double    Minimum font size in pt. Defaults to ", DEFAULT_MIN_FONT_SIZE, ".\n"
		        "  --max double    Maximum font size in pt. Defaults to ", DEFAULT_MAX_FONT_SIZE, ".\n"
		        "  --overwrite     Overwrite output file. Defaults to false.\n"
		        "  --help          Print this help.\n"
		        "\n"
		        "Input Data:\n",
		        FILE_FORMAT, "\n"
		        "...");
	}

	@property
	{
		pure nothrow string inputFile()   { return _inputFile; }
		pure nothrow string outputFile()  { return _outputFile; }
		pure nothrow string font()        { return _font; }
		pure nothrow double maxFontSize() { return _maxFontSize; }
		pure nothrow double minFontSize() { return _minFontSize; }
		pure nothrow double overwriteFile() { return _overwriteFile; }
	}

private:

	string _inputFile;
	string _outputFile;
	string _font;
	double _maxFontSize;
	double _minFontSize;
	bool _overwriteFile;
}

unittest
{
	WordcloudArguments arguments = WordcloudArguments(["wordcloud", "outfile.png"]);
	assert(arguments.inputFile is null);
	assert(arguments.outputFile == "outfile.png");
	assert(arguments.font !is null && arguments.font == "");
	assert(arguments.minFontSize == WordcloudArguments.DEFAULT_MIN_FONT_SIZE);
	assert(arguments.maxFontSize == WordcloudArguments.DEFAULT_MAX_FONT_SIZE);

	assertThrown!ArgumentException(WordcloudArguments(["wordcloud"]));
	assertThrown!ArgumentException(WordcloudArguments(["wordcloud", "-bfoo", "outfile.png"]));
	assertThrown!ArgumentException(WordcloudArguments(["wordcloud", "foo", "outfile.png"]));

	arguments = WordcloudArguments(["wordcloud", "-i/tmp/foo", "outfile.png"]);
	assert(arguments.inputFile == "/tmp/foo");
	arguments = WordcloudArguments(["wordcloud", "-i=/tmp/foo", "outfile.png"]);
	assert(arguments.inputFile == "/tmp/foo");
	arguments = WordcloudArguments(["wordcloud", "--i=/tmp/foo", "outfile.png"]);
	assert(arguments.inputFile == "/tmp/foo");
	arguments = WordcloudArguments(["wordcloud", "--i", "/tmp/foo", "outfile.png"]);
	assert(arguments.inputFile == "/tmp/foo");

	arguments = WordcloudArguments(["wordcloud", "-ffoo", "outfile.png"]);
	assert(arguments.font == "foo");
	arguments = WordcloudArguments(["wordcloud", "-f=foo", "outfile.png"]);
	assert(arguments.font == "foo");
	arguments = WordcloudArguments(["wordcloud", "--f=foo", "outfile.png"]);
	assert(arguments.font == "foo");
	arguments = WordcloudArguments(["wordcloud", "--f", "foo", "outfile.png"]);
	assert(arguments.font == "foo");

	arguments = WordcloudArguments(["wordcloud", "-min=100", "outfile.png"]);
	assert(arguments.minFontSize == 100);
	arguments = WordcloudArguments(["wordcloud", "--min=100", "outfile.png"]);
	assert(arguments.minFontSize == 100);
	arguments = WordcloudArguments(["wordcloud", "--min", "100", "outfile.png"]);
	assert(arguments.minFontSize == 100);

	arguments = WordcloudArguments(["wordcloud", "-max=100", "outfile.png"]);
	assert(arguments.maxFontSize == 100);
	arguments = WordcloudArguments(["wordcloud", "--max=100", "outfile.png"]);
	assert(arguments.maxFontSize == 100);
	arguments = WordcloudArguments(["wordcloud", "--max", "100", "outfile.png"]);
	assert(arguments.maxFontSize == 100);


	arguments = WordcloudArguments(["wordcloud", "-i/tmp/foo", "-i/tmp/bar", "outfile.png"]);
	assert(arguments.inputFile == "/tmp/bar");

	arguments = WordcloudArguments(["wordcloud", "-i/tmp/foo", "-ffont", "-min=100", "-max=200", "outfile.png"]);
	assert(arguments.inputFile == "/tmp/foo");
	assert(arguments.outputFile == "outfile.png");
	assert(arguments.font == "font");
	assert(arguments.minFontSize == 100);
	assert(arguments.maxFontSize == 200);
}

/// ArgumentException is thrown when wrong options are given to the program.
class ArgumentException : Exception
{
	nothrow this(string msg, string file = __FILE__, size_t line = __LINE__)
	{
		super(msg, file, line);
	}
}
