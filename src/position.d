// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import rectangle;
import point;

/// Position rectangles such that there are no two intersecting rectangles in
/// rectangles
void positionRectangles(Rectangle[] rectangles)
{
	import std.random;
	auto gen = Random(unpredictableSeed);
	foreach (i, ref r; rectangles)
	{
		float t = 0;
		do
		{
			Point position = spiral(t);
			r.moveUpperLeftTo(position);
			t += 0.1;
		} while (r.intersects(rectangles[0 .. i]));
	}
}

unittest
{
	auto rectangles = [ Rectangle(UpperLeft(0,0), LowerRight(10,20)),
	                    Rectangle(UpperLeft(0,0), LowerRight(30,10)),
	                    Rectangle(UpperLeft(0,0), LowerRight(80,80)) ];
	positionRectangles(rectangles);
	import std.stdio;
	writeln(rectangles);
}

bool intersects(Rectangle r, Rectangle[] rectangles)
{
	foreach (rect; rectangles)
	{
		if (r.intersectsWith(rect)) return true;
	}
	return false;
}


Point spiral(float t)
{
	import std.conv;
	import std.math;
	float x = t * cos(t);
	float y = t * sin(t);
	return Point(roundTo!int(x), roundTo!int(y));
}
