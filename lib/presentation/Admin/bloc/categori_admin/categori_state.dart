part of 'categori_bloc.dart';

sealed class CategoriState {}

final class CategoriInitial extends CategoriState {}


class CategoryLoading extends CategoriState {}

class CategoryLoaded extends CategoriState {
  final List<CategoryDataModel> categories;

  CategoryLoaded(this.categories);
}

class CategorySuccess extends CategoriState {
  final String message;

  CategorySuccess(this.message);
}

class CategoryError extends CategoriState {
  final String error;

  CategoryError(this.error);
}