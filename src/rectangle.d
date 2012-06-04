// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

import std.conv;
version(unittest) import core.exception;

import point;

/// UpperLeft is a synonym for Point.
alias Point UpperLeft;
/// LowerRight is a synonym for Point.
alias Point LowerRight;

/**
 * A Rectangle
 *
 * Authors: Jens K. Mueller, jkm@informatik.uni-jena.de
 *
 */
struct Rectangle
{
	/// Constructs a Rectangle from given upperLeft and given
	/// lowerRight.
	/// Params: upperLeft = is the upper left of the Rectangle.
	///         lowerRight = is the lower right of the Rectangle.
	nothrow this(UpperLeft upperLeft, LowerRight lowerRight)
	{
		_upperLeft = upperLeft;
		_lowerRight = lowerRight;
	}

	// TODO
	// should be pure and nothrow
	invariant()
	{
		assert(isValid(),
		       text("⌜", _upperLeft, " has to be above and left of ", _lowerRight, "⌟"));
	}

	unittest
	{
		import std.exception;
		assertThrown!AssertError(Rectangle(UpperLeft(), LowerRight()));

		// above but not left
		assertThrown!AssertError(Rectangle(UpperLeft(1,1), LowerRight(1,2)));

		// left but not above
		assertThrown!AssertError(Rectangle(UpperLeft(1,1), LowerRight(2,1)));
	}

	/// Returns: This Rectangle as string. E.g. "⌜(0,0),(1,1)⌟" for
	/// Rectangle(UpperLeft(0,0), LowerRight(1,1)).
	string toString() const
	{
		return "⌜" ~ to!string(_upperLeft) ~ "," ~ to!string(_lowerRight) ~ "⌟";
	}

	unittest {
		Rectangle r = Rectangle(UpperLeft(0,0), LowerRight(1,1));
		assert(to!string(r) == "⌜(0,0),(1,1)⌟");
		r = Rectangle(Point(1,2), Point(3,4));
		assert(to!string(r) == "⌜(1,2),(3,4)⌟");

		const Rectangle rc = Rectangle(UpperLeft(0,0), LowerRight(1,1));
		assert(to!string(rc) == "⌜(0,0),(1,1)⌟");
	}

	/// Returns: The upperLeft of this Rectangle.
	@property
	pure nothrow UpperLeft upperLeft() const { return _upperLeft; }
	/// Returns: The upperLeft of this Rectangle.
	@property
	pure nothrow LowerRight lowerRight() const { return _lowerRight; }

	/// Returns: The leftmost x coordinate of this Rectangle.
	@property
	pure nothrow int left() const { return _upperLeft.x; }
	/// Returns: The rightmost x coordinate of this Rectangle.
	@property
	pure nothrow int right() const { return _lowerRight.x; }
	/// Returns: The topmost y coordinate of this Rectangle.
	@property
	pure nothrow int top() const { return _upperLeft.y; }
	/// Returns: The bottommost y coordinate of this Rectangle.
	@property
	pure nothrow int bottom() const { return _lowerRight.y; }

	unittest
	{
		Rectangle r = Rectangle(UpperLeft(0,0), LowerRight(1,1));
		assert(r.upperLeft == UpperLeft(0,0));
		assert(r.lowerRight == LowerRight(1,1));
		assert(r.left == 0);
		assert(r.right == 1);
		assert(r.top == 0);
		assert(r.bottom == 1);

		r = Rectangle(Point(1,2), Point(3,4));
		assert(r.upperLeft == UpperLeft(1,2));
		assert(r.lowerRight == LowerRight(3,4));
		assert(r.left == 1);
		assert(r.right == 3);
		assert(r.top == 2);
		assert(r.bottom == 4);
	}

	/// Returns: The width of this Rectangle.
	@property
	pure nothrow int width() const { return _lowerRight.x - _upperLeft.x; }
	/// Returns: The height of this Rectangle.
	@property
	pure nothrow int height() const { return _lowerRight.y - _upperLeft.y; }

	unittest
	{
		Rectangle r = Rectangle(UpperLeft(0,0), LowerRight(1,1));
		assert(r.width == 1);
		assert(r.height == 1);
	}

	alias moveUpperLeftTo moveRectangle;
	/// Moves this Rectangle such that p is the new upperLeft.
	/// Params: p = is the new upperLeft.
	nothrow void moveUpperLeftTo(Point p)
	{
		// TODO
		// this should be like this
		// in {int oldWidth = width;}
		// out {assert(oldWidth == width);}
		// and compiled only in non-release mode
		version(unittest) {
			int oldWidth = width;
			int oldHeight = height;
			scope(exit) {
				assert(oldWidth == width);
				assert(oldHeight == height);
			}
		}
		_lowerRight -= _upperLeft - p;
		_upperLeft = p;
	}

	unittest
	{
		Rectangle r = Rectangle(UpperLeft(0,0), LowerRight(1,1));
		r.moveUpperLeftTo(Point(1,1));
		assert(r == Rectangle(UpperLeft(1,1), LowerRight(2,2)));
	}

	nothrow void moveCenterTo(Point p)
	{
		// TODO
		// this should be like this
		// in {int oldWidth = width;}
		// out {assert(oldWidth == width);}
		// and compiled only in non-release mode
		version(unittest) {
			int oldWidth = width;
			int oldHeight = height;
			scope(exit) {
				assert(oldWidth == width);
				assert(oldHeight == height);
			}
		}
		p.x = p.x - width/2;
		p.y = p.y - height/2;
		moveUpperLeftTo(p);
	}

	/// Test for intersection of this and other Rectangle.
	/// Params: other = is the Rectangle to test with
	/// Returns: true, if this Rectangle and other Rectangle intersect.
	/// Otherwise, false.
	pure nothrow bool intersectsWith(Rectangle other) const
	{
		if (other.right <= left) return false;
		if (other.left >= right) return false;
		if (other.top >= bottom) return false;
		if (other.bottom <= top) return false;

		return true;
	}

	unittest
	{
		Rectangle r = Rectangle(UpperLeft(0,0), LowerRight(5,5));
		assert(r.intersectsWith(r) == true);
		assert(r.intersectsWith(Rectangle(UpperLeft(5,0),
		                                  LowerRight(10,5))) == false);
		assert(r.intersectsWith(Rectangle(UpperLeft(0,5),
		                                  LowerRight(5,10))) == false);
		assert(r.intersectsWith(Rectangle(UpperLeft(-5,0),
		                                  LowerRight(0,5))) == false);
		assert(r.intersectsWith(Rectangle(UpperLeft(0,-5),
		                                  LowerRight(5,0))) == false);

		assert(r.intersectsWith(Rectangle(UpperLeft(2,-1),
		                                  LowerRight(3,1))) == true);
		assert(r.intersectsWith(Rectangle(UpperLeft(4,2),
		                                  LowerRight(6,3))) == true);
		assert(r.intersectsWith(Rectangle(UpperLeft(2,4),
		                                  LowerRight(3,6))) == true);
		assert(r.intersectsWith(Rectangle(UpperLeft(-1,2),
		                                  LowerRight(1,3))) == true);
	}

private:
	UpperLeft _upperLeft;
	LowerRight _lowerRight;

	/// Returns: true, if upperLeft is strictly above and strictly left of
	/// lowerRight. Otherwise, false.
	pure nothrow bool isValid() const
	{
		return _upperLeft.x < _lowerRight.x && _upperLeft.y < _lowerRight.y;
	}
}
