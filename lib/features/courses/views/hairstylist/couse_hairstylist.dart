import 'package:flutter/material.dart';
import 'package:tintly/shared/designs/dimens.dart';
import 'package:tintly/shared/designs/icons.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';
import 'package:tintly/shared/widgets/custom_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class CouseHairstylist extends StatelessWidget {
  const CouseHairstylist({super.key});

  Future<void> _openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Не удалось открыть ссылку: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> lessons = [
      {
        'title': 'Стартовый набор парикмахера',
        'url': 'https://www.youtube.com/watch?v=15qNqyVsank',
      },
      {
        'title': 'Как держать ножницы',
        'url': 'https://www.youtube.com/watch?v=zpxYGMyMw8M',
      },
      {
        'title': '«Линия» в квадратной геометрии',
        'url': 'https://www.youtube.com/watch?v=Qk-rVlCUtuI',
      },
      {
        'title': 'Обратный каскад',
        'url': 'https://www.youtube.com/watch?v=LiCoajZ8tmg',
      },
      {
        'title': 'Челка «Шторка»',
        'url': 'https://www.youtube.com/watch?v=QyEu1b6lYtA',
      },
      {
        'title': 'Техника «Слои»',
        'url': 'https://www.youtube.com/watch?v=4u1A_5YsiPo',
      },
      {
        'title': 'Техника «Линия»',
        'url': 'https://www.youtube.com/watch?v=Xuxq5uHj-kI',
      },
      {
        'title': 'Вторичное окрашивание',
        'url': 'https://www.youtube.com/watch?v=3FDEoJSqyXw',
      },
      {
        'title': 'Осветление маслом',
        'url': 'https://www.youtube.com/watch?v=n7AvJJ2FkiA',
      },
      {
        'title': 'Техника "каре на удлинение"',
        'url': 'https://www.youtube.com/watch?v=X6iOlWfkzAc',
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(title: 'Курс парикмахера'),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.padding16),
        child: ListView.separated(
          itemCount: lessons.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return CustomListTile(
              title: lesson['title']!,
              trailing: chevronRight,
              onTap: () => _openYoutube(lesson['url']!),
            );
          },
        ),
      ),
    );
  }
}
