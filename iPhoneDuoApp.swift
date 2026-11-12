import SwiftUI

@main
struct iPhoneDuoApp: App {
    var body: some Scene {
        WindowGroup {
            DuoView()
                .preferredColorScheme(.dark)
                .statusBarHidden(true)
        }
    }
}
