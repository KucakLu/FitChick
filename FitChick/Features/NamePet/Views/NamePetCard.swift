//
//  NamePetCard.swift
//  FitChick
//
//  Created by Hendra Irawan on 22/05/26.
//

import SwiftUI
import SwiftData

struct NamePetCard: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [UserAccount]

    private let autoFocus: Bool

    @State private var petName = ""
    @State private var navigateToDashboard = false
    @FocusState private var isPetNameFocused: Bool

    init(autoFocus: Bool = true) {
        self.autoFocus = autoFocus
    }

    private var isSaveDisabled: Bool {
        petName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("What's your pet name?")
                .font(AppFont.bodyBold)
                .foregroundStyle(AppColor.neutral900)

            TextField("your pet name", text: $petName)
                .font(AppFont.calloutBold)
                .foregroundStyle(AppColor.neutral800Text)
                .focused($isPetNameFocused)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .disableAutocorrection(true)
                .submitLabel(.done)
                .animation(nil, value: isPetNameFocused)
                .padding(.horizontal, 16)
                .frame(height: 46)
                .background(
                    RoundedRectangle(cornerRadius: 9)
                        .fill(AppColor.secondary75Field)
                )

            PrimaryButton(title: "Save", isDisabled: isSaveDisabled) {
                savePetName()
            }
        }
        .task {
            guard autoFocus else { return }
            DispatchQueue.main.async {
                self.isPetNameFocused = true
            }
        }
        .onSubmit {
            isPetNameFocused = false
            savePetName()
        }
        .padding(16)
        .frame(maxWidth: 362)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppColor.secondary0Surface)
        )
        .fullScreenCover(isPresented: $navigateToDashboard) {
            DashboardView()
        }
    }

    private func savePetName() {
        let savedPetName = petName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !savedPetName.isEmpty else { return }

        if let currentUser = currentUser {
            currentUser.petName = savedPetName
        } else {
            let userId = KeychainManager.shared.retrieve(key: "appleUserId") ?? "localUser"
            let newUser = UserAccount(userId: userId, petName: savedPetName)
            modelContext.insert(newUser)
        }

        DispatchQueue.main.async { self.isPetNameFocused = false }

        do {
            try modelContext.save()
            navigateToDashboard = true
        } catch {
            print("Failed to save pet name: \(error.localizedDescription)")
        }
    }

    private var currentUser: UserAccount? {
        guard let userId = KeychainManager.shared.retrieve(key: "appleUserId") else {
            return users.first
        }

        return users.first { $0.userId == userId } ?? users.first
    }
}

#Preview {
    let container = try! ModelContainer(
        for: UserAccount.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    ZStack {
        AppColor.secondary300Main
            .ignoresSafeArea()

        NamePetCard()
    }
    .modelContainer(container)
}
