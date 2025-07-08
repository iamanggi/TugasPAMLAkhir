import 'package:bloc/bloc.dart';
import 'package:tilik_desa/data/model/request/admin/categori_admin_request_model.dart';
import 'package:tilik_desa/data/model/response/admin/categori_admin_response_model.dart';
import 'package:tilik_desa/data/repository/Admin/categori_admin_respositori.dart';

part 'categori_event.dart';
part 'categori_state.dart';

class CategoriBloc extends Bloc<CategoriEvent, CategoriState> {
  final CategoryRepository repository;

  CategoriBloc(this.repository) : super(CategoriInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());
      final result = await repository.getCategories();
      result.fold(
        (error) => emit(CategoryError(error)),
        (categories) => emit(CategoryLoaded(categories)),
      );
    });

    on<CreateCategory>((event, emit) async {
      emit(CategoryLoading());
      final result = await repository.addCategory(event.model);
      result.fold(
        (error) => emit(CategoryError(error)),
        (data) => emit(CategorySuccess("Kategori berhasil ditambahkan")),
      );
    });

    on<UpdateCategory>((event, emit) async {
      emit(CategoryLoading());
      final result = await repository.updateCategory(event.id, event.model);
      result.fold(
        (error) => emit(CategoryError(error)),
        (data) => emit(CategorySuccess("Kategori berhasil diperbarui")),
      );
    });

    on<DeleteCategory>((event, emit) async {
      emit(CategoryLoading());
      final result = await repository.deleteCategory(event.id);
      result.fold(
        (error) => emit(CategoryError(error)),
        (success) => emit(CategorySuccess("Kategori berhasil dihapus")),
      );
    });
  }
}
