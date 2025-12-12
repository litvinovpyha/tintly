import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tintly/features/price/bloc/price_event.dart';
import 'package:tintly/features/price/models/price.dart';
import 'package:tintly/features/price/bloc/price_state.dart';
import 'package:tintly/features/price/repository/price_repository.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  final PriceRepository r;
  List<Price> _allPrices = [];

  PriceBloc(this.r) : super(PriceInitial()) {
    on<LoadPrices>((event, emit) async {
      emit(PriceLoading());
      try {
        _allPrices = await r.getAll();
        emit(PriceLoaded(_allPrices));
      } catch (e) {
        emit(PriceError(e.toString()));
      }
    });
    on<LoadPricesByField>((event, emit) async {
      emit(PriceLoading());
      try {
        _allPrices = await r.getAllByField(event.field);
        emit(PriceLoaded(_allPrices));
      } catch (e) {
        emit(PriceError(e.toString()));
      }
    });
    on<AddPrice>((event, emit) async {
      try {
        final newPrice = await r.create(event.price);
        _allPrices = List<Price>.from(_allPrices)..add(newPrice);
        emit(PriceLoaded(_allPrices));
      } catch (e) {
        emit(PriceError(e.toString()));
      }
    });
    on<CreatePrice>((event, emit) async {
      try {
        final newPrice = Price(
          id: '',
          brand: event.brand,
          field: event.field,
          pricePerUnit: event.pricePerUnit,
          placeholder: event.placeholder,
        );
        await r.create(newPrice);
        _allPrices = List<Price>.from(_allPrices)..add(newPrice);

        emit(PriceLoaded(_allPrices));
      } catch (e) {
        emit(PriceError(e.toString()));
      }
    });

    on<UpdatePrice>((event, emit) async {
      try {
        final updatedPrice = await r.update(event.price);
        if (updatedPrice != null) {
          final index = _allPrices.indexWhere((c) => c.id == updatedPrice.id);
          if (index != -1) _allPrices[index] = updatedPrice;
          emit(PriceLoaded(_allPrices));
        }
      } catch (e) {
        emit(PriceError(e.toString()));
      }
    });
    on<UpdatePricePerUnit>((event, emit) async {
      try {
        final price = _allPrices.firstWhere((p) => p.id == event.priceId);
        final double pricePerUnit =
            double.tryParse(event.pricePerUnit) ?? price.pricePerUnit;
        final updatedPriceData = price.copyWith(pricePerUnit: pricePerUnit);
        final updatedPrice = await r.update(updatedPriceData);
        if (updatedPrice != null) {
          final index = _allPrices.indexWhere((c) => c.id == updatedPrice.id);
          if (index != -1) _allPrices[index] = updatedPrice;
          emit(PriceLoading());
          emit(PriceLoaded(_allPrices));
        }
      } catch (e) {
        emit(PriceError(e.toString()));
      }
    });

    on<DeletePrice>((event, emit) async {
      try {
        await r.delete(event.id);
        _allPrices = _allPrices.where((c) => c.id != event.id).toList();
        emit(PriceLoaded(_allPrices));
      } catch (e) {
        emit(PriceError(e.toString()));
      }
    });
  }
}
