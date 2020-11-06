import "dart:math" show pi, sin, cos;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../data/feeling.dart';

class _Coordinates {
  final double x;
  final double y;

  _Coordinates(this.x, this.y);
}

/// The radius of the inner "parent feeling" circle
final double _innerCircleRadius = 50;

/// The bounding rectangle of the inner "parent feeling" circle
final Rect _innerCircleBoundingRect = Rect.fromCenter(
    center: Offset.zero,
    width: 2 * _innerCircleRadius,
    height: 2 * _innerCircleRadius);

/// The radius of the outer "child feelings" circle
final double _outerCircleRadius = 150;

/// The bounding rectangle of the inner "parent feeling" circle
final Rect _outerCircleBoundingRect = Rect.fromCenter(
    center: Offset.zero,
    width: 2 * _outerCircleRadius,
    height: 2 * _outerCircleRadius);

final _stroke = Paint()
  ..style = PaintingStyle.stroke
  ..strokeWidth = 4
  ..color = Colors.black;

Paint _fill(Color color) => Paint()
  ..style = PaintingStyle.fill
  ..color = color;

// to convert between radial and cartesian coordinates,
// we take the sine and cosine (yay trig!) and scale it by the radius
_Coordinates _cartesianify(double theta, double radius) =>
    _Coordinates(cos(theta) * radius, sin(theta) * radius);

class FeelingWheel extends StatefulWidget {
  final List<Feeling> _topLevelFeelings;
  final void Function(Feeling) _onFeelingTapCallback;

  FeelingWheel(this._topLevelFeelings, this._onFeelingTapCallback);

  factory FeelingWheel.fullWheel(void Function(Feeling) onFeelingTapCallback) =>
      FeelingWheel(Feeling.wheel(), onFeelingTapCallback);

  @override
  _FeelingWheelState createState() =>
      _FeelingWheelState(this._topLevelFeelings, null);
}

class _FeelingWheelState extends State<FeelingWheel> {
  /// child feelings to display
  List<Feeling> _currentChildFeelings;

  /// parent feeling to display, if any
  Feeling _currentParentFeeling;

  _FeelingWheelState(this._currentChildFeelings, this._currentParentFeeling);

  /// arc length, in radians, each child feeling should take up
  double get _theta => (1.0 / this._currentChildFeelings.length) * 2.0 * pi;

  void _onTap(Feeling feeling) {
    widget._onFeelingTapCallback(feeling);
    if (feeling.children != null) {
      setState(() {
        this._currentParentFeeling = feeling;
        this._currentChildFeelings = feeling.children;
      });
    }
  }

  // TODO this needs to take into account size stuff because otherwise we don't get hit detection
  /// Create CustomPaint widgets in slice shapes for child feelings
  List<Widget> _sliceFeelings() => this
      ._currentChildFeelings
      .asMap()
      .entries
      .map((entry) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (details) {
            print('${entry.value.name}');
          },
          child: CustomPaint(
              painter: SlicePainter(
                  entry.value.color, entry.key * this._theta, this._theta))))
      .toList();

  /// Create CustomPaint widgets in annular sector shapes for child feelings
  /// with a GestureDetector around them to call this._onFeelingTapCallback
  List<Widget> _annularSectorFeelings() => this
      ._currentChildFeelings
      .asMap()
      .entries
      .map((entry) => GestureDetector(
          onTap: () => widget._onFeelingTapCallback(entry.value),
          child: CustomPaint(
              painter: AnnularSectorPainter(
                  entry.value.color, entry.key * this._theta, this._theta))))
      .toList();

  Widget _circleFeeling() => GestureDetector(
        onTap: () => widget._onFeelingTapCallback(this._currentParentFeeling),
        child: CustomPaint(
            painter: CirclePainter(this._currentParentFeeling.color)),
      );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Container(
          width: constraints.biggest.shortestSide,
          height: constraints.biggest.shortestSide,
          child: Stack(
            alignment: Alignment.center,
            children: this._currentParentFeeling == null
                ? _sliceFeelings()
                : [..._annularSectorFeelings(), _circleFeeling()],
          )),
    );
  }
}

abstract class FeelingPainter extends CustomPainter {
  final Color _color;
  final double _radialOffset;
  final double _theta;
  final _path = Path();

  FeelingPainter(this._color, this._radialOffset, this._theta);

  @override
  bool shouldRepaint(covariant FeelingPainter oldDelegate) => false;
}

class SlicePainter extends FeelingPainter {
  SlicePainter(Color color, double radialOffset, double theta)
      : super(color, radialOffset, theta);

  @override
  void paint(Canvas canvas, Size size) {
    // starting at the center
    _path.moveTo(size.width / 2, size.height / 2);

    // draw an arc
    _path.arcTo(
        // along the outer circle
        _outerCircleBoundingRect,
        // starting at the appropriate offset (minus ninety degrees)
        this._radialOffset - pi / 2,
        // arc for theta radians
        this._theta,
        // and connect it via a line segment to the center
        false);

    // and let's go home
    _path.close();

    canvas.drawPath(_path, _fill(this._color));
    canvas.drawPath(_path, _stroke);
  }

  @override
  bool hitTest(Offset position) {
    return _path.contains(position);
  }
}

class AnnularSectorPainter extends FeelingPainter {
  AnnularSectorPainter(Color color, double radialOffset, double theta)
      : super(color, radialOffset, theta);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }
}

class CirclePainter extends FeelingPainter {
  CirclePainter(Color color) : super(color, null, null);

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  }
}

// class FeelingWheelPainter extends CustomPainter {
//   final Feeling _parentFeeling;
//   final List<Feeling> _childFeelings;
//   final void Function(Feeling) _onFeelingTapCallback;

//   FeelingWheelPainter(
//       this._parentFeeling, this._childFeelings, this._onFeelingTapCallback) {
//     print(this._childFeelings);
//     print(widget._childFeelings);
//   }

//   @override
//   void paint(Canvas canvas, Size size) {
//     final stroke = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4
//       ..color = Colors.black;

//     if (this._parentFeeling != null) {
//       final fill = Paint()
//         ..style = PaintingStyle.fill
//         ..color = this._parentFeeling.color;

//       canvas.drawCircle(size.center(Offset.zero), _parentFeelingRadius, fill);
//       canvas.drawCircle(size.center(Offset.zero), _parentFeelingRadius, stroke);
//     }

//     // for (var i = 0; i < this._childFeelings.length; i++) {
//     //   final fill = Paint()
//     //     ..style = PaintingStyle.fill
//     //     ..color = this._childFeelings[i].color;

//     //   canvas.drawCircle(size.center(_childFeelingOffset(i)), 10, fill);
//     // }
//   }

//   @override
//   bool shouldRepaint(FeelingWheelPainter oldDelegate) {
//     // TODO: implement shouldRepaint
//     return false;
//   }
// }
