import Foundation

@main
struct StorageAndRouterChecks {
    static func main() async {
        await MainActor.run {
            let suiteName = "FitChick.regression.\(UUID().uuidString)"
            guard let defaults = UserDefaults(suiteName: suiteName) else {
                fail("Could not create test defaults suite")
            }

            defer {
                defaults.removePersistentDomain(forName: suiteName)
            }

            let store = AppStateStore(defaults: defaults, observesDefaultsChanges: false)

            assertEqual(store.coinCount, 0, "new store starts with zero coins")
            store.addCoins(60)
            assertEqual(store.coinCount, 60, "coin additions update store")

            let blackHat = CollectionData.items.first { $0.svgAssetName == "black_hat" }
                ?? CollectionData.items[0]
            store.setUnlockedItems(UnlockedItems(assetNames: [blackHat.svgAssetName]))
            assertTrue(
                CollectionData.isItemOwned(blackHat, unlockedItems: store.unlockedItems),
                "typed unlocked storage controls ownership checks"
            )

            let equippedItems = EquippedPetItems(head: EquippedPetItem(item: blackHat))
            store.setEquippedPetItems(equippedItems)
            assertEqual(store.equippedPetItems, equippedItems, "equipment writes stay typed")

            let todayKey = "2026-5-27"
            defaults.set(todayKey, forKey: "dailyMission.rewardNotification.step-8000")
            assertFalse(
                store.isDailyRewardCollected(id: "step-8000", todayKey: todayKey),
                "daily mission claim notification does not mark reward collected"
            )
            assertEqual(store.coinCount, 60, "claim notification does not add coins")

            store.markDailyRewardCollected(id: "step-8000", todayKey: todayKey)
            assertTrue(
                store.isDailyRewardCollected(id: "step-8000", todayKey: todayKey),
                "daily reward collection is readable after write"
            )

            let reloadedStore = AppStateStore(defaults: defaults, observesDefaultsChanges: false)
            assertEqual(reloadedStore.coinCount, 60, "coin count persists through defaults")
            assertEqual(reloadedStore.unlockedItems.assetNames, [blackHat.svgAssetName], "unlocks persist through defaults")
            assertEqual(reloadedStore.equippedPetItems, equippedItems, "equipment persists through defaults")

            let router = AppRouter()
            assertEqual(router.root, .onboarding, "router starts on onboarding")
            router.showDashboard()
            assertEqual(router.root, .dashboard, "router can switch to dashboard root")
            router.showOnboarding()
            assertEqual(router.root, .onboarding, "router can return to onboarding root")

            print("StorageAndRouterChecks passed")
        }
    }

    private static func assertTrue(
        _ condition: Bool,
        _ message: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard condition else {
            fail(message, file: file, line: line)
        }
    }

    private static func assertFalse(
        _ condition: Bool,
        _ message: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertTrue(!condition, message, file: file, line: line)
    }

    private static func assertEqual<T: Equatable>(
        _ actual: T,
        _ expected: T,
        _ message: String,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard actual == expected else {
            fail("\(message). Expected \(expected), got \(actual)", file: file, line: line)
        }
    }

    private static func fail(
        _ message: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Never {
        fatalError("Regression check failed: \(message)", file: file, line: line)
    }
}
