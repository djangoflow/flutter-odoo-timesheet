import 'package:djangoflow_sync_drift_odoo/djangoflow_sync_drift_odoo.dart';
import 'package:djangoflow_sync_foundation/djangoflow_sync_foundation.dart';

abstract class AppDriftOdooSyncRepository<T extends SyncModel,
    TTable extends BaseTable> extends DriftOdooSyncRepository<T, TTable> {
  AppDriftOdooSyncRepository(
    super.primaryBackend,
    super.secondaryBackend,
    super.syncStrategy,
  );

  @override // TODO  make new methods for localOnly operations to separate
  Future<List<T>> getAll({bool returnOnlySecondary = false}) async {
    if (!returnOnlySecondary && await isPrimaryBackendAvailable) {
      try {
        final items = await primaryBackend.getAll();
        await updateSecondaryBackend(items);
        await (syncStrategy as DriftOdooSyncStrategy<T, TTable>)
            .syncBatch(items, primaryBackend, modelName: modelName);

        return items;
      } catch (e, stackTrace) {
        logger.e(
          'Failed to fetch items from primary backend:',
          error: e,
          stackTrace: stackTrace,
        );
        return secondaryBackend.getAll();
      }
    }

    return secondaryBackend.getAll();
  }

  @override
  Future<T?> getById(int id, {bool returnOnlySecondary = false}) async {
    if (!returnOnlySecondary && await isPrimaryBackendAvailable) {
      try {
        final item = await primaryBackend.getById(id);
        if (item != null) {
          await updateSecondaryBackend([item]);
          await (syncStrategy as DriftOdooSyncStrategy<T, TTable>)
              .syncBatch([item], primaryBackend, modelName: modelName);
        }

        return item;
      } catch (e, stackTrace) {
        logger.e(
          'Failed to fetch item from primary backend:',
          error: e,
          stackTrace: stackTrace,
        );
        return secondaryBackend.getById(id);
      }
    }
    return secondaryBackend.getById(id);
  }

  @override
  Future<T> update(T item, {bool onlyUpdateSecondary = false}) async {
    if (await isPrimaryBackendAvailable && !onlyUpdateSecondary) {
      try {
        final updatedItem = await primaryBackend.update(item);
        await updateSecondaryBackend([updatedItem]);
        await (syncStrategy as DriftOdooSyncStrategy<T, TTable>)
            .syncBatch([updatedItem], primaryBackend, modelName: modelName);
        return updatedItem;
      } catch (e, stackTrace) {
        logger.e(
          'Failed to update item in primary backend:',
          error: e,
          stackTrace: stackTrace,
        );
        return _updateSecondaryWithPendingSync(item);
      }
    } else {
      return _updateSecondaryWithPendingSync(item);
    }
  }

  Future<T> _updateSecondaryWithPendingSync(T item) async {
    final updatedItem = await secondaryBackend.update(item);
    final syncStrategy =
        (this.syncStrategy as DriftOdooSyncStrategy<T, TTable>);
    final backendId = syncStrategy.driftBackendId;
    await (syncStrategy).syncRegistryRepository.upsertRegistry(
          modelName: modelName,
          modelRecordId: item.id,
          backendId: backendId,
          recordWriteDate: item.writeDate,
          pendingSync: true,
        );

    return updatedItem;
  }
}
