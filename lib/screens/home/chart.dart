import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:adguard_home_manager/widgets/line_chart.dart';

import 'package:adguard_home_manager/providers/app_config_provider.dart';

class HomeChart extends StatelessWidget {
  final List<int> data;
  final String label;
  final String primaryValue;
  final String secondaryValue;
  final Color color;
  final int hoursInterval;

  const HomeChart({
    super.key,
    required this.data,
    required this.label,
    required this.primaryValue,
    required this.secondaryValue,
    required this.color,
    required this.hoursInterval
  });

  @override
  Widget build(BuildContext context) {
    final appConfigProvider = Provider.of<AppConfigProvider>(context);

    final bool isEmpty = data.every((i) => i == 0);

    if (!(appConfigProvider.hideZeroValues == true && isEmpty == true)) {
      List<DateTime> dateTimes = [];
      DateTime currentDate = DateTime.now().subtract(Duration(hours: hoursInterval*data.length+1));
      for (var i = 0; i < data.length; i++) {
        currentDate = currentDate.add(Duration(hours: hoursInterval));
        dateTimes.add(currentDate);
      }
      
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: !isEmpty ? 10 : 15
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          label, 
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface
                          ),
                        ),
                      ),
                      !isEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                primaryValue,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              Text(
                                secondaryValue,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color
                                ),
                              )
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                primaryValue,
                                style: TextStyle(
                                  color: color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "($secondaryValue)",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color
                                ),
                              )
                            ],
                          )
                    ],
                  ),
                ),
                if (!isEmpty) SizedBox(
                  width: double.maxFinite,
                  height: 150,
                  child: CustomLineChart(
                    data: data, 
                    color: color,
                    dates: dateTimes,
                    daysInterval: hoursInterval == 24,
                    context: context,
                  )
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              thickness: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 16),
        ],
      );
    }
    else {
      return const SizedBox();
    }
  }
}