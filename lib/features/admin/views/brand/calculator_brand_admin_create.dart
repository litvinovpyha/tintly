import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tintly/features/products/models/brand.dart';
import 'package:tintly/features/products/controllers/brand_controller.dart';
import 'package:tintly/shared/utils/id_generator.dart';
import 'package:tintly/shared/widgets/custom_app_bar.dart';

class CreateBrandPage extends StatefulWidget {
  const CreateBrandPage({super.key});

  @override
  State<CreateBrandPage> createState() => _CreateBrandPageState();
}

class _CreateBrandPageState extends State<CreateBrandPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BrandController>(context, listen: false).loadItems();
    });
  }

  Future<void> _createBrand() async {
    final name = _nameController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    if (name.isEmpty) return;

    final brandController = Provider.of<BrandController>(
      context,
      listen: false,
    );
    await brandController.create(
      Brand(
        id: IdGenerator.generate(),
        name: name,
        imageUrl: imageUrl,
        placeholder: name,
        isActive: true,
      ),
    );

    _nameController.clear();
    _imageUrlController.clear();
  }

  Future<void> _editBrand(Brand brand) async {
    _nameController.text = brand.name;
    _imageUrlController.text = brand.imageUrl ?? '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Редактировать бренд"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Название"),
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: "URL картинки"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updated = Brand(
                id: brand.id,
                name: _nameController.text,
                imageUrl: _imageUrlController.text,
                placeholder: _nameController.text,
                isActive: brand.isActive,
              );
              final brandController = Provider.of<BrandController>(
                context,
                listen: false,
              );
              await brandController.update(updated);
              Navigator.pop(context);
            },
            child: const Text("Сохранить"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Создать бренд'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Название"),
                ),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: "URL картинки"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _createBrand,
                  child: const Text("Добавить бренд"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<BrandController>(
              builder: (context, brandController, child) {
                if (brandController.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final brands = brandController.items;
                if (brands.isEmpty) {
                  return const Center(child: const Text("Нет брендов"));
                }
                return ListView.builder(
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    return ListTile(
                      leading:
                          brand.imageUrl != null && brand.imageUrl!.isNotEmpty
                          ? Image.asset(
                              brand.imageUrl!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_not_supported),
                      title:  Text(brand.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editBrand(brand),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final brandController =
                                  Provider.of<BrandController>(
                                    context,
                                    listen: false,
                                  );
                              await brandController.delete(brand.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
