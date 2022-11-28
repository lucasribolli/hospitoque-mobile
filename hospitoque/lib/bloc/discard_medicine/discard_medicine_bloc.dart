import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' show debugPrint, immutable;
import 'package:hospitoque/model/medicine.dart';
import 'package:hospitoque/repositories/constants.dart';
import 'package:hospitoque/repositories/repository.dart';
import 'package:hospitoque/utils/date_extensions.dart';

part 'discard_medicine_event.dart';
part 'discard_medicine_state.dart';

class DiscardMedicineBloc
    extends Bloc<DiscardMedicineEvent, DiscardMedicineState> {
  static const _TAG = '[DiscardMedicineBloc] ';

  DiscardMedicineBloc() : super(DiscardMedicineState.initial()) {
    on<ListAllMedicinesEvent>(_onListAll);
    on<SelectMedicineEvent>(_onSelectMedicine);
  }

  Future<void> _onListAll(ListAllMedicinesEvent event, emit) async {
    try {
      List<Medicine> medicines =
          await HospitoqueRepository.getMedicines(keyword: '');
      List<DiscartableMedicine> expirationMedicines =
          _orderMedicines(medicines);
      debugPrint('$_TAG expirationMedicines -> $expirationMedicines');
      emit(state.copyWith(medicines: expirationMedicines));
    } catch (e) {
      debugPrint('$_TAG error on list all: $e');
    }
  }

  List<DiscartableMedicine> _orderMedicines(List<Medicine> medicines) {
    List<Medicine> orderedByExpiration = [...medicines];
    orderedByExpiration
        .sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
    DateTime now = DateTime.now().ignoreDays;
    return orderedByExpiration.map(
      (m) {
        return DiscartableMedicine(
          medicine: m,
          timeToExpiration:
              _getTimeToExpiration(now, m.expirationDate.ignoreDays),
        );
      },
    ).toList();
  }

  TimeToExpiration _getTimeToExpiration(DateTime now, DateTime expirationDate) {
    if (expirationDate.isBefore(now)) {
      return TimeToExpiration.past;
    }
    if (expirationDate.difference(now).inDays <= Constants.DAYS_IN_MONTH) {
      return TimeToExpiration.sameMonth;
    }
    return TimeToExpiration.future;
  }

  void _onSelectMedicine(SelectMedicineEvent event, Emitter<DiscardMedicineState> emit) {
    int index =
        state.medicines.indexWhere((m) => m == event.medicine);
    List<DiscartableMedicine> medicines = [...state.medicines];
    DiscartableMedicine selectedMedicine = medicines[index];
    medicines[index] = selectedMedicine.copyWith(selected: !selectedMedicine.selected);
    emit(state.copyWith(medicines: medicines));
  }
}
