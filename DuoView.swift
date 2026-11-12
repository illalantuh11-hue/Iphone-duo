import SwiftUI

struct DuoView: View {
    @State private var isOpen: Bool = false
    @State private var foldProgress: CGFloat = 0.0
    
    @StateObject private var screen1 = ScreenState()
    @StateObject private var screen2 = ScreenState()
    
    // Пропорции по спецификации 117.8 x 84.1 / 164.6
    let halfWidth: CGFloat = 210
    let totalHeight: CGFloat = 600
    var totalWidth: CGFloat { halfWidth * 2 }
    
    var body: some View {
        ZStack {
            Color(white: 0.88).ignoresSafeArea()
            
            VStack(spacing: 24) {
                // 3D-корпус
                ZStack(alignment: .leading) {
                    // Левая половина (задняя панель)
                    RoundedRectangle(cornerRadius: 54)
                        .fill(
                            LinearGradient(
                                colors: [Color(white: 0.15), Color(white: 0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: halfWidth, height: totalHeight)
                        .overlay(
                            RoundedRectangle(cornerRadius: 54)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.25), Color.white.opacity(0.05)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: .black.opacity(0.4), radius: 30, x: 0, y: 20)
                    
                    // Правая половина + экраны
                    HStack(spacing: 0) {
                        Spacer().frame(width: halfWidth)
                        
                        ZStack {
                            // Внутренний экран (виден при развороте)
                            ScreenView(state: screen2, isOuter: false)
                                .frame(width: halfWidth, height: totalHeight)
                                .background(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                                .opacity(foldProgress > 0.5 ? 1 : 0)
                            
                            // Внешний экран (виден при складывании)
                            ScreenView(state: screen1, isOuter: true)
                                .frame(width: halfWidth, height: totalHeight)
                                .background(Color.black)
                                .clipShape(RoundedRectangle(cornerRadius: 40))
                                .opacity(foldProgress < 0.5 ? 1 : 0)
                                .rotation3DEffect(
                                    .degrees(isOpen ? -180 : 0),
                                    axis: (x: 0, y: 1, z: 0),
                                    anchor: .leading,
                                    perspective: 0.5
                                )
                        }
                        .frame(width: halfWidth, height: totalHeight)
                        .shadow(color: .black.opacity(0.5), radius: 30, x: 0, y: 20)
                    }
                }
                .frame(width: isOpen ? totalWidth : halfWidth, height: totalHeight)
                .animation(.spring(response: 0.7, dampingFraction: 0.75), value: isOpen)
                .animation(.spring(response: 0.7, dampingFraction: 0.75), value: foldProgress)
                
                // Кнопка складывания
                Button(action: toggleFold) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.left.arrow.right")
                        Text(isOpen ? "Сложить" : "Развернуть")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Capsule())
                }
            }
        }
    }
    
    private func toggleFold() {
        // Бесшовная передача состояния
        if isOpen {
            screen1.openApps = screen2.openApps
            screen1.unlocked = screen2.unlocked
            screen2.openApps = []
        } else {
            screen2.openApps = screen1.openApps
            screen2.unlocked = screen1.unlocked
            screen1.openApps = []
        }
        
        isOpen.toggle()
        withAnimation(.spring(response: 0.7, dampingFraction: 0.75)) {
            foldProgress = isOpen ? 1 : 0
        }
    }
}
