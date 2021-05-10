import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:liv_social/features/domain/usecases/logout_usecase.dart';

enum IndexPage {
  feed,
  profile,
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._logOutUseCase,
  ) : super(const HomeState(IndexPage.feed));

  final LogOutUseCase _logOutUseCase;

  void changePage(IndexPage page) {
    if (page == IndexPage.feed) {
      emit(HomeReloadFeedState(page));
    }
    emit(HomeState(page));
  }

  void logout() {
    _logOutUseCase.logout();
    emit(HomeLogoutState(state.page));
  }

  void reloadFeed() {
    emit(HomeState(state.page));
    emit(HomeReloadFeedState(state.page));
  }
}

class HomeState extends Equatable {
  final IndexPage page;

  const HomeState(this.page);

  @override
  List<Object> get props => [page];
}

class HomeLogoutState extends HomeState {
  HomeLogoutState(IndexPage page) : super(page);

  @override
  List<Object> get props => [page];
}

class HomeReloadFeedState extends HomeState {
  HomeReloadFeedState(
    IndexPage page,
  ) : super(page);

  @override
  List<Object> get props => [page];
}
