import Combine
import Foundation

@MainActor
final class AppRouter: ObservableObject {
    enum Root: Equatable {
        case onboarding
        case dashboard
    }

    @Published private(set) var root: Root
    @Published private(set) var dashboardRouteID = UUID()

    init(root: Root = .onboarding) {
        self.root = root
    }

    func showOnboarding() {
        root = .onboarding
    }

    func showDashboard() {
        dashboardRouteID = UUID()
        root = .dashboard
    }
}
