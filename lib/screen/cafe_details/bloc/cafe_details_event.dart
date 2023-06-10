part of 'cafe_details_bloc.dart';

abstract class CafeDetailsEvent extends Equatable {
  const CafeDetailsEvent();

  @override
  List<Object> get props => [];
}

class CafeDetailsInitial extends CafeDetailsEvent {}
