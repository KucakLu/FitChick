import Combine
import Foundation

struct DailyRewardStorageState: Equatable {
    var collectedIDs: Set<String>
    var collectedDate: String
}

@MainActor
final class AppStateStore: ObservableObject {
    static let shared = AppStateStore()

    private enum Key {
        static let isLoggedIn = "isLoggedIn"
        static let coinCount = "coinCount"
        static let totalGachaCount = "totalGachaCount"
        static let dailyRewardIDs = "dailyProgress.collectedRewardIDs"
        static let dailyRewardDate = "dailyProgress.collectedRewardDate"
    }

    private let defaults: UserDefaults
    private var defaultsObserver: NSObjectProtocol?
    private var isWritingDefaults = false

    @Published private(set) var isLoggedIn: Bool
    @Published private(set) var coinCount: Int
    @Published private(set) var totalGachaCount: Int
    @Published private(set) var unlockedItems: UnlockedItems
    @Published private(set) var equippedPetItems: EquippedPetItems
    @Published private(set) var dailyRewardState: DailyRewardStorageState

    init(
        defaults: UserDefaults = .standard,
        observesDefaultsChanges: Bool = true
    ) {
        self.defaults = defaults
        isLoggedIn = defaults.bool(forKey: Key.isLoggedIn)
        coinCount = defaults.integer(forKey: Key.coinCount)
        totalGachaCount = defaults.integer(forKey: Key.totalGachaCount)
        unlockedItems = UnlockedItems(
            encodedString: defaults.string(forKey: CollectionData.unlockedStorageKey) ?? "{}"
        )
        equippedPetItems = EquippedPetItems(
            encodedString: defaults.string(forKey: EquippedPetItems.storageKey)
                ?? EquippedPetItems.empty.encodedString
        )
        dailyRewardState = Self.readDailyRewardState(from: defaults)

        if observesDefaultsChanges {
            defaultsObserver = NotificationCenter.default.addObserver(
                forName: UserDefaults.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let store = self else {
                    return
                }

                Task { @MainActor in
                    store.reloadFromDefaultsIfNeeded()
                }
            }
        }
    }

    deinit {
        if let defaultsObserver {
            NotificationCenter.default.removeObserver(defaultsObserver)
        }
    }

    func setIsLoggedIn(_ isLoggedIn: Bool) {
        write {
            self.isLoggedIn = isLoggedIn
            defaults.set(isLoggedIn, forKey: Key.isLoggedIn)
        }
    }

    func setCoinCount(_ coinCount: Int) {
        write {
            self.coinCount = max(coinCount, 0)
            defaults.set(self.coinCount, forKey: Key.coinCount)
        }
    }

    func addCoins(_ amount: Int) {
        setCoinCount(coinCount + amount)
    }

    func setTotalGachaCount(_ totalGachaCount: Int) {
        write {
            self.totalGachaCount = max(totalGachaCount, 0)
            defaults.set(self.totalGachaCount, forKey: Key.totalGachaCount)
        }
    }

    func setUnlockedItems(_ unlockedItems: UnlockedItems) {
        write {
            self.unlockedItems = unlockedItems
            defaults.set(unlockedItems.encodedString, forKey: CollectionData.unlockedStorageKey)
        }
    }

    func setEquippedPetItems(_ equippedPetItems: EquippedPetItems) {
        write {
            self.equippedPetItems = equippedPetItems
            defaults.set(equippedPetItems.encodedString, forKey: EquippedPetItems.storageKey)
        }
    }

    func updateGachaState(
        coinCount: Int,
        totalGachaCount: Int,
        unlockedItems: UnlockedItems
    ) {
        write {
            self.coinCount = max(coinCount, 0)
            self.totalGachaCount = max(totalGachaCount, 0)
            self.unlockedItems = unlockedItems
            defaults.set(self.coinCount, forKey: Key.coinCount)
            defaults.set(self.totalGachaCount, forKey: Key.totalGachaCount)
            defaults.set(unlockedItems.encodedString, forKey: CollectionData.unlockedStorageKey)
        }
    }

    func isDailyRewardCollected(id: String, todayKey: String) -> Bool {
        (dailyRewardState.collectedDate == todayKey && dailyRewardState.collectedIDs.contains(id))
            || defaults.string(forKey: legacyDailyRewardKey(for: id)) == todayKey
    }

    func markDailyRewardCollected(id: String, todayKey: String) {
        write {
            var updatedIDs = dailyRewardState.collectedDate == todayKey
                ? dailyRewardState.collectedIDs
                : []
            updatedIDs.insert(id)

            dailyRewardState = DailyRewardStorageState(
                collectedIDs: updatedIDs,
                collectedDate: todayKey
            )
            defaults.set(todayKey, forKey: Key.dailyRewardDate)
            defaults.set(updatedIDs.sorted().joined(separator: ","), forKey: Key.dailyRewardIDs)
            defaults.set(todayKey, forKey: legacyDailyRewardKey(for: id))
        }
    }

    static func preview(coinCount: Int = 0) -> AppStateStore {
        let suiteName = "FitChick.preview.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        let store = AppStateStore(defaults: defaults, observesDefaultsChanges: false)
        store.setCoinCount(coinCount)
        return store
    }

    private func write(_ update: () -> Void) {
        isWritingDefaults = true
        update()
        isWritingDefaults = false
    }

    private func reloadFromDefaultsIfNeeded() {
        guard isWritingDefaults == false else {
            return
        }

        isLoggedIn = defaults.bool(forKey: Key.isLoggedIn)
        coinCount = defaults.integer(forKey: Key.coinCount)
        totalGachaCount = defaults.integer(forKey: Key.totalGachaCount)
        unlockedItems = UnlockedItems(
            encodedString: defaults.string(forKey: CollectionData.unlockedStorageKey) ?? "{}"
        )
        equippedPetItems = EquippedPetItems(
            encodedString: defaults.string(forKey: EquippedPetItems.storageKey)
                ?? EquippedPetItems.empty.encodedString
        )
        dailyRewardState = Self.readDailyRewardState(from: defaults)
    }

    private static func readDailyRewardState(from defaults: UserDefaults) -> DailyRewardStorageState {
        DailyRewardStorageState(
            collectedIDs: Set(
                (defaults.string(forKey: Key.dailyRewardIDs) ?? "")
                    .split(separator: ",")
                    .map(String.init)
            ),
            collectedDate: defaults.string(forKey: Key.dailyRewardDate) ?? ""
        )
    }

    private func legacyDailyRewardKey(for id: String) -> String {
        "dailyMission.reward.\(id)"
    }
}
