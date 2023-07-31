import 'package:cafe_api/cafe_api.dart';
import 'package:flutter/material.dart';
import 'package:hispace_mobile_app/core/global/constans.dart';

class OpenHour extends StatelessWidget {
  const OpenHour({
    super.key,
    required this.cafe,
  });

  final Cafe cafe;

  final List<String> days = const [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jum\'at',
    'Sabtu',
    'Minggu',
  ];

  String getTime(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    int currentDay = now.weekday;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: kDefaultSpacing / 2),
          child:
              Text('Jam Buka', style: Theme.of(context).textTheme.titleMedium),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: 7,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var time = cafe.time.getFromIndex(index);

            return Padding(
              padding: const EdgeInsets.only(bottom: kDefaultSpacing / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 60, child: Text(days[index])),
                  if (time != null && time.openOnTheDay()) ...[
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyLarge,
                        children: [
                          TextSpan(text: getTime(time.open!)),
                          const TextSpan(text: ' - '),
                          TextSpan(text: getTime(time.close!)),
                          if (time.openOnTheDay() && index == currentDay)
                            const TextSpan(text: ' (Buka Sekarang)'),
                        ],
                      ),
                    ),
                  ],
                  if (time == null || !time.openOnTheDay())
                    const Text(' (Tutup)'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
