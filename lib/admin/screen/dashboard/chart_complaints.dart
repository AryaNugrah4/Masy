import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:masy/admin/screen/dashboard/indicator.dart';
import 'package:masy/shared/style.dart';

class ChartComplaints extends StatefulWidget {
  final double diajukanLength;
  final double diprosesLength;
  final double selesaiLength;
  final String diajukanPercentage;
  final String diprosesPercentage;
  final String selesaiPercentage;

  const ChartComplaints({
    Key? key,
    required this.diajukanLength,
    required this.diprosesLength,
    required this.selesaiLength,
    required this.diajukanPercentage,
    required this.diprosesPercentage,
    required this.selesaiPercentage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ChartComplaintsState();
}

class ChartComplaintsState extends State<ChartComplaints> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Card(
        color: accent,
        shadowColor: Colors.transparent,
        child: Row(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                        });
                      },
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 35,
                    sections: showingSections(
                      diajukanPercentage: widget.diajukanPercentage,
                      diprosesPercentage: widget.diprosesPercentage,
                      selesaiPercentage: widget.selesaiPercentage,
                      diajukanLength: widget.diajukanLength,
                      diprosesLength: widget.diprosesLength,
                      selesaiLength: widget.selesaiLength,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'Diajukan',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Diproses',
                  isSquare: true,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff845bef),
                  text: 'Selesai',
                  isSquare: true,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections({
    required String diajukanPercentage,
    required String diprosesPercentage,
    required String selesaiPercentage,
    required double diajukanLength,
    required double diprosesLength,
    required double selesaiLength,
  }) {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: diajukanLength.toDouble(),
            title: '$diajukanPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: diprosesLength.toDouble(),
            title: '$diprosesPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: selesaiLength.toDouble(),
            title: '$selesaiPercentage%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
