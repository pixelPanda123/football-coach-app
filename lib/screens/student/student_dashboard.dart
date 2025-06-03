                  child: RadarChart(
                    RadarChartData(
                      radarShape: RadarShape.polygon,
                      tickCount: 4,
                      ticksTextStyle: const TextStyle(color: Colors.transparent),
                      gridBorderData: const BorderSide(color: Colors.black12),
                      titleTextStyle: const TextStyle(fontSize: 12),
                      getTitle: (index) {
                        final titles = ['Technical', 'Tactical', 'Physical', 'Psychological'];
                        return titles[index];
                      },
                      dataSets: [
                        RadarDataSet(
                          fillColor: AppTheme.primaryColor.withOpacity(0.2),
                          borderColor: AppTheme.primaryColor,
                          entryRadius: 2,
                          dataEntries: [
                            const RadarEntry(value: 8), // Technical
                            const RadarEntry(value: 7), // Tactical
                            const RadarEntry(value: 9), // Physical
                            const RadarEntry(value: 6), // Psychological
                          ],
                        ),
                      ],
                    ),
                  ), 