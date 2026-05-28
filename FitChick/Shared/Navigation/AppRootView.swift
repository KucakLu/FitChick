import SwiftUI

struct AppRootView: View {
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        Group {
            switch router.root {
            case .onboarding:
                Onboarding()
            case .dashboard:
                DashboardView()
                    .id(router.dashboardRouteID)
            }
        }
    }
}

#Preview {
    AppRootView()
        .environmentObject(AppRouter())
        .environmentObject(AppStateStore.preview())
}
