import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/brand/bloc/brand_event.dart';
import 'package:tintly/features/brand/bloc/brand_state.dart';
import 'package:tintly/features/brand/models/brand.dart';
import 'package:tintly/features/brand/repository/brand_repository.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository r;
  List<Brand> _allBrands = [];
  BrandBloc(this.r) : super(BrandInitial()) {
    on<LoadBrands>((event, emit) async {
      emit(BrandLoading());

      try {
        _allBrands = await r.getAll();
        emit(BrandLoaded(_allBrands));
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });
    on<AddBrand>((event, emit) async {
      try {
        final newBrand = await r.create(event.brand);
        _allBrands = List<Brand>.from(_allBrands)..add(newBrand);
        emit(BrandLoaded(_allBrands));
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });

    on<UpdateBrand>((event, emit) async {
      try {
        final updatedBrand = await r.update(event.brand);
        if (updatedBrand != null) {
          final index = _allBrands.indexWhere((c) => c.id == updatedBrand.id);
          if (index != -1) _allBrands[index] = updatedBrand;
          emit(BrandLoaded(_allBrands));
        }
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });
    on<UpdateBrandByName>((event, emit) async {
      try {
        final oldBrand = _allBrands.firstWhere((u) => u.id == event.id);

        final updatedBrand = oldBrand.copyWith(name: event.newName);

        final savedBrand = await r.update(updatedBrand);

        if (savedBrand != null) {
          final index = _allBrands.indexWhere((c) => c.id == savedBrand.id);

          if (index != -1) {
            final updatedList = List<Brand>.from(
              _allBrands,
            ); // <-- СОЗДАНИЕ НОВОЙ КОПИИ
            updatedList[index] = savedBrand;
            _allBrands = updatedList; // Обновление приватной ссылки
          }
          emit(BrandLoaded(_allBrands));
        }
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });

    on<DeleteBrand>((event, emit) async {
      try {
        await r.delete(event.id);
        _allBrands = _allBrands.where((c) => c.id != event.id).toList();
        emit(BrandLoaded(_allBrands));
      } catch (e) {
        emit(BrandError(e.toString()));
      }
    });

    on<CreateBrandByName>((event, emit) async {
      final newBrand = await r.createByName(event.name);
      _allBrands = List<Brand>.from(_allBrands)..add(newBrand);
      emit(BrandLoaded(_allBrands));
    });
  }
}
