part of 'categori_bloc.dart';

sealed class CategoriEvent {}

class LoadCategories extends CategoriEvent {}

class CreateCategory extends CategoriEvent {
  final CategoryRequestModel model;

  CreateCategory(this.model);
}

class UpdateCategory extends CategoriEvent {
  final int id;
  final CategoryRequestModel model;

  UpdateCategory({required this.id, required this.model});
}

class DeleteCategory extends CategoriEvent {
  final int id;

  DeleteCategory(this.id);
}