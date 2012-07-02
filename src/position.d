// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import rectangle;
import point;

/// Position rectangles such that there are no two intersecting rectangles in
/// rectangles
void positionRectangles(Rectangle[] rectangles)
{
	foreach (i, ref r; rectangles)
	{
		float t = 0;
		do
		{
			Point newPosition = spiral(t);

			enum ratio = 4.0 / 3.0;
			newPosition.x = roundTo!(int)(newPosition.x * ratio);
			newPosition.y = roundTo!(int)(newPosition.y * 1/ratio);

			r.moveCenterTo(newPosition);
			++t;
		} while (r.intersects(rectangles[0 .. i]));
	}
}

unittest
{
}

bool intersects(Rectangle r, Rectangle[] rectangles)
{
	foreach (rect; rectangles)
	{
		if (r.intersectsWith(rect)) return true;
	}
	return false;
}


import std.math;
import std.conv;
Point spiral(float t)
{
	// Archimedean spiral
	float x = t * cos(t);
	float y = t * sin(t);
	return Point(roundTo!(int)(x), roundTo!(int)(y));
}

unittest
{
	auto reference = [
	    0.0  : Point(0,0),                   PI/2     : Point(0,roundTo!(int)(PI/2)),
	    PI   : Point(roundTo!(int)(-PI),0),  3.0/2*PI : Point(0,roundTo!(int)(-3.0/2*PI)),
	    2*PI : Point(roundTo!(int)(2*PI),0)
	];
	foreach (k, v; reference)
	{
		assert(v == spiral(k), to!string(spiral(k)));
	}
}
