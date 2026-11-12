import SwiftUI

struct ScreenView: View {
    @ObservedObject var state: ScreenState
    let isOuter: Bool
    
    private var gridCols: Int { isOuter ? 4 : 6 }
    private var iconSize: CGFloat { isOuter ? 60 : 70 }
    private var fontSize: CGFloat { isOuter ? 11 : 12 }
    
    var body: some View {
        ZStack {
            // Обои (фиолетовые, как в iOS 26)
            LinearGradient(
                colors: [
                    Color(red: 0.35, green: 0.3, blue: 1.0),
                    Color(red: 0.75, green: 0.3, blue: 0.9),
                    Color(red: 1.0, green: 0.4, blue: 0.5)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Рабочий стол
            VStack(spacing: 0) {
                Spacer().frame(height: 40)
                
                LazyVGrid(
                    columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: gridCols),
                    spacing: 20
                ) {
                    ForEach(isOuter ? Array(allApps.prefix(12)) : allApps) { app in
                        AppIconView(app: app, size: iconSize, fontSize: fontSize) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                                state.openApp(app.id)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Док
                HStack(spacing: 16) {
                    ForEach(Array(allApps.suffix(4))) { app in
                        AppIconView(app: app, size: 60, fontSize: 0, showName: false) {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                                state.openApp(app.id)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            }
            
            // Статус-бар
            VStack {
                HStack {
                    Text(currentTime)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "wifi")
                        Image(systemName: "battery.100")
                    }
                    .font(.system(size: 13))
                    .foregroundColor(.white)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                Spacer()
            }
            
            // Окна приложений (параллельные анимации)
            ForEach(state.openApps, id: \.self) { appId in
                if let app = allApps.first(where: { $0.id == appId }) {
                    AppWindowView(app: app) {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            state.closeApp(appId)
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.3).combined(with: .opacity),
                        removal: .scale(scale: 0.3).combined(with: .opacity)
                    ))
                }
            }
            
            // Экран блокировки
            if !state.unlocked {
                LockScreenView(state: state)
                    .transition(.move(edge: .bottom))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 40))
    }
    
    private var currentTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}

struct AppIconView: View {
    let app: AppItem
    let size: CGFloat
    let fontSize: CGFloat
    var showName: Bool = true
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: size * 0.22)
                    .fill(app.color)
                    .frame(width: size, height: size)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                
                Image(systemName: app.sfSymbol)
                    .font(.system(size: size * 0.45, weight: .medium))
                    .foregroundColor(app.color == .white || app.color == .yellow ? .black : .white)
            }
            .onTapGesture(perform: action)
            
            if showName {
                Text(app.name)
                    .font(.system(size: fontSize))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
        }
    }
}

struct AppWindowView: View {
    let app: AppItem
    let closeAction: () -> Void
    @State private var appeared = false
    
    var body: some View {
        ZStack {
            app.color
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: app.sfSymbol)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(app.color == .white || app.color == .yellow ? .black : .white)
                    .scaleEffect(appeared ? 1 : 0.5)
                    .opacity(appeared ? 1 : 0)
                
                Text(app.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(app.color == .white || app.color == .yellow ? .black : .white)
                    .opacity(appeared ? 1 : 0)
                
                Spacer()
                
                Button(action: closeAction) {
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 120, height: 5)
                }
                .padding(.bottom, 12)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                appeared = true
            }
        }
    }
}

struct LockScreenView: View {
    @ObservedObject var state: ScreenState
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.1, green: 0.1, blue: 0.2),
                    Color(red: 0.2, green: 0.1, blue: 0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 8) {
                Spacer().frame(height: 80)
                
                Text(currentDate)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                
                Text(currentTime)
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Проведите вверх")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 40)
            }
        }
        .offset(y: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = min(0, value.translation.height)
                }
                .onEnded { value in
                    if value.translation.height < -100 {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                            state.unlocked = true
                        }
                    }
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        dragOffset = 0
                    }
                }
        )
    }
    
    private var currentTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
    
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: Date())
    }
}
