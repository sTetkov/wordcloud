// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import rectangle;
import point;

/// Position rectangles such that there are no two intersecting rectangles in
/// rectangles
void positionRectangles(Rectangle[] rectangles)
{
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
	return false;
}
