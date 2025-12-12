import 'package:hive/hive.dart';
import 'package:tintly/shared/utils/id_generator.dart';
import '../features/brand/models/brand.dart';

Future<void> brandSeeder() async {
  var box = await Hive.openBox<Brand>('brand');

  if (box.isNotEmpty) {
    return;
  }

  final defaultBrands = [
    Brand(
      id: IdGenerator.generate(),
      name: 'Artisto',
      imageUrl: 'assets/brands/artisto.jpg',
      isActive: true,
      placeholder: 'Введите количество...',
    ),
    Brand(
      id: IdGenerator.generate(),
      name: 'Bouticle',
      imageUrl: 'assets/brands/bouticle.webp',
      isActive: true,
      placeholder: 'Введите количество...',
    ),
    Brand(
      id: IdGenerator.generate(),
      name: 'CDC',
      imageUrl: 'assets/brands/del-color.webp',
      isActive: true,
      placeholder: 'Введите количество...',
    ),
    Brand(
      id: IdGenerator.generate(),
      name: 'J.Maki',
      imageUrl: 'assets/brands/j-maki.webp',
      isActive: true,
      placeholder: 'Введите количество...',
    ),
    Brand(
      id: IdGenerator.generate(),
      name: 'Prosalon',
      imageUrl: 'assets/brands/prosalon.png',
      isActive: true,
      placeholder: 'Введите количество...',
    ),
    Brand(
      id: IdGenerator.generate(),
      name: 'Oyster',
      imageUrl: 'assets/brands/oyster.png',
      isActive: true,
      placeholder: 'Введите количество...',
    ),
    Brand(
      id: IdGenerator.generate(),
      name: 'Kleral',
      imageUrl: 'assets/brands/kleral.jpg',
      isActive: true,
      placeholder: 'Введите количество...',
    ),
    Brand(
      id: IdGenerator.generate(),
      name: 'Ollin',
      imageUrl: 'assets/brands/ollin.jpg',
      isActive: true,
      placeholder: 'Введите количество...',
    ),
    Brand(
      id: IdGenerator.generate(),
      name: 'Estel',
      imageUrl: 'assets/brands/estel.png',
      isActive: true,
      placeholder: 'Введите количество...',
    ),
  ];

  for (var brand in defaultBrands) {
    await box.put(brand.id, brand);
  }
}
