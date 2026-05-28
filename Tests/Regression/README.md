# Regression Checks

Run the storage/router seam check from the repository root:

```sh
xcrun swiftc -module-cache-path /private/tmp/fitchick-module-cache -parse-as-library FitChick/Domain/Catalogs/CollectionItem.swift FitChick/Shared/Utilities/AppStateStore.swift FitChick/Shared/Navigation/AppRouter.swift Tests/Regression/StorageAndRouterChecks.swift -o /private/tmp/fitchick-storage-router-checks
/private/tmp/fitchick-storage-router-checks
```

Expected output:

```text
StorageAndRouterChecks passed
```
