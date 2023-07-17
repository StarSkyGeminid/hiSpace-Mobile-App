import 'package:bloc/bloc.dart';
import 'package:cafe_repository/cafe_repository.dart';
import 'package:equatable/equatable.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc(CafeRepository cafeRepository)
      : _cafeRepository = cafeRepository,
        super(const WishlistState()) {
    on<WishlistInitial>(_onInitial);
    on<WishlistOnTap>(_onTap);
    on<WishlistOnRefresh>(_onRefresh);
    on<WishlistOnLoadMore>(_onLoadMore);
    on<WishlistOnToggleFavorite>(_onToggleFavorite);
    on<WishlistEvent>((event, emit) {});
  }

  final CafeRepository _cafeRepository;

  int _currentPage = 0;

  bool isFetching = false;

  Future<void> _onInitial(
      WishlistInitial event, Emitter<WishlistState> emit) async {
    emit(const WishlistState(status: WishlistStatus.loading));

    await _cafeRepository.user.getWishlist(page: _currentPage++);

    await emit.forEach(
      _cafeRepository.user.getCafes(),
      onData: (cafes) => state.copyWith(
        status: WishlistStatus.success,
        cafes: cafes,
      ),
      onError: (_, __) => state.copyWith(status: WishlistStatus.failure),
    );
  }

  Future<void> _onTap(WishlistOnTap event, Emitter<WishlistState> emit) async {
    emit(state.copyWith(status: WishlistStatus.loading));
  }

  Future<void> _onRefresh(
      WishlistOnRefresh event, Emitter<WishlistState> emit) async {
    emit(state.copyWith(status: WishlistStatus.loading));

    _currentPage = 0;
    _cafeRepository.user.getWishlist(page: _currentPage++);
  }

  Future<void> _onLoadMore(
      WishlistOnLoadMore event, Emitter<WishlistState> emit) async {
    if (isFetching) return;

    try {
      isFetching = true;
      _cafeRepository.user.getWishlist(page: _currentPage++);
      isFetching = false;
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.failure));
      isFetching = false;
    }
  }

  Future<void> _onToggleFavorite(
      WishlistOnToggleFavorite event, Emitter<WishlistState> emit) async {
    try {
      emit(state.copyWith(status: WishlistStatus.initial));

      _cafeRepository.user.toggleFavorite(event.index);
    } catch (e) {
      emit(state.copyWith(status: WishlistStatus.failure));
    }
  }
}
