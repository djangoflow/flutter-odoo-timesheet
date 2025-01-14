import 'package:bloc/bloc.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';
import 'package:timesheets/features/sync/sync.dart';

class SyncCubit<T extends SyncModel> extends Cubit<SyncState> {
  SyncCubit({
    required this.repository,
    required this.syncRegistryRepository,
    required this.backendId,
    required this.modelName,
  }) : super(
          const SyncState(status: SyncStatus.syncInitial),
        );

  final SyncRepository<T> repository;
  final AppSyncRegistryRepository syncRegistryRepository;
  final String backendId;
  final String modelName;

  Future<void> sync({bool isBackgroundSync = false}) async {
    emit(state.copyWith(
      status: SyncStatus.syncInProgress,
      isBackgroundSync: isBackgroundSync,
    ));
    try {
      await repository.sync();
      final pendingItems = await syncRegistryRepository.getPendingSyncRecords(
        backendId,
        modelName,
      );
      emit(state.copyWith(
        status: SyncStatus.syncSuccess,
        pendingSyncRecordIds:
            pendingItems.map((item) => item.modelRecordId).toList(),
      ));
    } catch (e, stackTrace) {
      logger.e(
        'Failed to sync $modelName',
        error: e,
        stackTrace: stackTrace,
      );
      emit(
        state.copyWith(
          status: SyncStatus.syncFailure,
        ),
      );
      rethrow;
    } finally {
      emit(state.copyWith(isBackgroundSync: false));
    }
  }

  Future<void> loadPendingSyncRegistries({List<int>? ids}) async {
    final pendingItems = await syncRegistryRepository.getPendingSyncRecords(
      backendId,
      modelName,
      recordIds: ids,
    );
    emit(state.copyWith(
      pendingSyncRecordIds:
          pendingItems.map((item) => item.modelRecordId).toList(),
    ));
  }
}
