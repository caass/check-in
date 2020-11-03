import 'package:flutter/widgets.dart';
import 'package:charts_flutter/flutter.dart';
import '../data/feeling.dart';

class FeelingWheel extends StatelessWidget {
  final List<Feeling> childFeelings;
  final Feeling parentFeeling;

  FeelingWheel(this.childFeelings, {this.parentFeeling});

  /// Creates the top-level Feeling Wheel
  factory FeelingWheel.topLevel() {
    return FeelingWheel(Feeling.wheel());
  }

  /// Turn a list of feelings into data the pie chart can render
  List<Series<Feeling, int>> _createSeries(List<Feeling> childFeelings) {
    final slicePercentage = (100 / childFeelings.length).floor() - 1;
    return [
      Series<Feeling, int>(
          id: 'feelings',
          data: childFeelings,
          colorFn: (feeling, _) => Color(
              r: feeling.color.red,
              g: feeling.color.green,
              b: feeling.color.blue),
          labelAccessorFn: (feeling, _) =>
              '${feeling.name} ${feeling.emoji.char}',
          domainFn: (_, i) => i,
          measureFn: (_, __) => slicePercentage),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      _createSeries(this.childFeelings),
      animate: true,
      defaultRenderer: ArcRendererConfig(
          arcWidth: 120, arcRendererDecorators: [ArcLabelDecorator()]),
    );
  }
}
