// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import word;

import std.algorithm;
import std.typecons;

/// compute font size from word frequency
/// the font size is scaled linearly between a minimal font size and a maximal
/// font size
void computeFontSize(Word[] words, in double minFontSize, in double maxFontSize)
{
	if (!words.length) return;

	auto minMax = reduce!(min, max)(tuple(double.max, double.min), map!("a.frequency")(words));
	auto min = minMax[0];
	auto max = minMax[1];
	assert(min <= max);

	foreach (ref word; words)
	{
		// TODO
		// floating point equality comparison
		word.frequency = minFontSize + (min == max ? 0 : (maxFontSize - minFontSize) * scaleLinearlyToZeroOne(word.frequency, min, max));
	}
}

unittest
{
	import std.conv;
	Word[] words;

	computeFontSize(words, 0.0, 10.0);
	assert(!words.length);

	words ~= Word("foo", 0.0);
	computeFontSize(words, 0.0, 10.0);
	assert(words == [Word("foo", 0.0)]);

	computeFontSize(words, 1.0, 10.0);
	assert(words == [Word("foo", 1.0)]);

	words ~= Word("bar", 10.0);
	computeFontSize(words, 1.0, 10.0);
	assert(words == [Word("foo", 1.0), Word("bar", 10.0)], to!string(words));

	computeFontSize(words, 0.0, 5.0);
	assert(words == [Word("foo", 0.0), Word("bar", 5.0)], to!string(words));

	words ~= Word("foobar", 10.0);
	computeFontSize(words, 0.0, 5.0);
	assert(words == [Word("foo", 0.0), Word("bar", 2.5), Word("foobar", 5.0)], to!string(words));
	computeFontSize(words, 0.0, 5.0);
	assert(words == [Word("foo", 0.0), Word("bar", 2.5), Word("foobar", 5.0)], to!string(words));
}

import std.math;

double scaleLinearlyToZeroOne(double value, double min, double max)
in
{
	assert(min < max);
	assert(min <= value && value <= max);
}
out (result)
{
	assert(0.0 <= result && result <= 1.0);
}
body
{
	return (value - min) / (max - min);
}

unittest
{
	assert(scaleLinearlyToZeroOne(0.0, 0.0, 1.0) == 0.0);
	assert(scaleLinearlyToZeroOne(1.0, 0.0, 1.0) == 1.0);

	assert(scaleLinearlyToZeroOne(0.0, 0.0, 4.0) == 0.0);
	assert(scaleLinearlyToZeroOne(2.0, 0.0, 4.0) == 0.5);
	assert(scaleLinearlyToZeroOne(4.0, 0.0, 4.0) == 1.0);
}
