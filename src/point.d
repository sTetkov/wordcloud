// Copyright Jens K. Mueller
// Friedrich-Schiller-University Jena
//

// TODO
// is it possible to use std.typecons
// alias Tuple!(int, "x", int, "y") Point;
// and then define opBinary(op)(Point lhs, Point rhs)
// which will be called via UFCS (uniform function call syntax)
// and further let opAssign etc. (all that need this) forward to use these.
// this allows perfect encapsulation (see Scott Meyers)
// p1 + p2 is not properly rewritten

import std.conv;

/**
 * A Point
 *
 * Authors: Jens K. Mueller, jkm@informatik.uni-jena.de
 *
 */
struct Point
{
	/// Constructs a Point from given x and y coordinate.
	/// Params: x = is the x coordinate.
	///         y = is the y coordinate.
	pure nothrow this(int x, int y)
	{
		_x = x;
		_y = y;
	}

	/// Returns: This Point as string. E.g. "(1, 1)" for Point(1, 1).
	string toString() const
	{
		return "(" ~ to!string(_x) ~ ", " ~ to!string(_y) ~ ")";
	}

	unittest
	{
		Point p;
		assert(to!string(p) == "(0, 0)");
		assert(p.toString() == "(0, 0)");

		p = Point(1, 2);
		assert(to!string(p) == "(1, 2)");

		const Point p2 = Point(1,2);
		assert(to!string(p2) == "(1, 2)");
	}

	/// Returns: The x coordinate of this Point.
	@property
	pure nothrow int x() const { return _x; }
	/// Returns: The y coordinate of this Point.
	@property
	pure nothrow int y() const { return _y; }

	unittest
	{
		Point p;
		assert(p.x == 0);
		assert(p.y == 0);

		p = Point(1, 2);
		assert(p.x == 1);
		assert(p.y == 2);
	}

	/// Sets this x coordinate to given x coordinate.
	/// Parameters: x = is the new x coordinate.
	/// Returns: The new x coordinate.
	@property
	nothrow int x(int x) { return _x = x; }
	/// Sets this y coordinate to given y coordinate.
	/// Parameters: y = is the new y coordinate.
	/// Returns: The new y coordinate.
	@property
	nothrow int y(int y) { return _y = y; }

	unittest
	{
		Point p;
		assert((p.x = 1) == 1);
		assert((p.y = 2) == 2);

		p = Point(1, 2);
		assert((p.x = 4) == 4);
		assert((p.y = 5) == 5);
	}

	/// Adds/Subtracts Point rhs to this Point returning a new Point. This
	/// Point and Point rhs are added/subtracted by component-wise
	/// addition/subtraction of the x and y coordinate.
	/// Params: rhs = is the right-hand side Point
	/// Returns: A new Point such that x == this.x op rhs.x and y == this.y op
	/// rhs.y
	pure nothrow Point opBinary(string op) (const Point rhs) const if (op == "+" || op == "-")
	{
		return Point(mixin("_x" ~ op ~ "rhs._x"),
		             mixin("_y" ~ op ~ "rhs._y"));
	}

	unittest
	{
		Point p1;
		Point p2 = Point(1,2);
		assert(p1 + p2 == Point(1,2));

		assert(p1 - p2 == Point(-1,-2));
	}

	/// Adds/Subtracts Point rhs to this Point.
	/// Params: rhs = is right-hand side Point
	/// Returns: This Point such that this.x = this.x op rhs.x and this.y =
	/// this.y op rhs.y
	nothrow ref Point opOpAssign(string op) (const Point rhs) if (op == "+" || op == "-")
	{
		mixin("_x" ~ op ~ "=rhs.x;");
		mixin("_y" ~ op ~ "=rhs.y;");
		return this;
	}

	unittest
	{
		Point p1;
		p1 += Point(1,2);
		assert(p1 == Point(1,2));
		p1 -= Point(3,4);
		assert(p1 == Point(-2,-2));
	}

	/// Returns: the Point with largest coordinate in x and y direction.
	@property
	static pure nothrow Point max() { return Point(typeof(_x).max, typeof(_y).max); }

	/// Returns: the Point with smallest coordinate in x and y direction.
	@property
	static pure nothrow Point min() { return Point(typeof(_x).min, typeof(_y).min); }

private:
	int _x;
	int _y;
}

/// The origin is at (0, 0) which is the upper left in the coordinate system.
/// The x coordinates increase downwards and the y coordinates increase
/// rightwards.
enum origin = Point(0, 0);
