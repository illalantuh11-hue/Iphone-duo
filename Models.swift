import SwiftUI

struct AppItem: Identifiable, Hashable {
    let id: String
    let name: String
    let sfSymbol: String
    let color: Color
}

let allApps: [AppItem] = [
    AppItem(id: "ph", name: "Фото", sfSymbol: "photo.on.rectangle", color: .white),
    AppItem(id: "cam", name: "Камера", sfSymbol: "camera.fill", color: .gray),
    AppItem(id: "clk", name: "Часы", sfSymbol: "clock.fill", color: .black),
    AppItem(id: "cal", name: "Календарь", sfSymbol: "calendar", color: .white),
    AppItem(id: "wx", name: "Погода", sfSymbol: "cloud.sun.fill", color: .blue),
    AppItem(id: "map", name: "Карты", sfSymbol: "map.fill", color: .green),
    AppItem(id: "nt", name: "Заметки", sfSymbol: "note.text", color: .yellow),
    AppItem(id: "rem", name: "Напоминания", sfSymbol: "checklist", color: .orange),
    AppItem(id: "stk", name: "Акции", sfSymbol: "chart.line.uptrend.xyaxis", color: .black),
    AppItem(id: "bk", name: "Книги", sfSymbol: "book.fill", color: .orange),
    AppItem(id: "hl", name: "Здоровье", sfSymbol: "heart.fill", color: .white),
    AppItem(id: "set", name: "Настройки", sfSymbol: "gearshape.fill", color: .gray),
    AppItem(id: "tel", name: "Телефон", sfSymbol: "phone.fill", color: .green),
    AppItem(id: "web", name: "Браузер", sfSymbol: "safari.fill", color: .blue),
    AppItem(id: "msg", name: "Сообщения", sfSymbol: "message.fill", color: .green),
    AppItem(id: "mus", name: "Музыка", sfSymbol: "music.note", color: .pink),
    AppItem(id: "fil", name: "Файлы", sfSymbol: "folder.fill", color: .blue),
    AppItem(id: "sh", name: "Команды", sfSymbol: "square.stack.3d.up.fill", color: .indigo),
    AppItem(id: "tv", name: "TV", sfSymbol: "tv.fill", color: .black),
    AppItem(id: "pod", name: "Подкасты", sfSymbol: "waveform", color: .purple),
    AppItem(id: "wal", name: "Кошелёк", sfSymbol: "creditcard.fill", color: .black),
    AppItem(id: "frd", name: "Локатор", sfSymbol: "location.fill", color: .green),
    AppItem(id: "mea", name: "Рулетка", sfSymbol: "ruler.fill", color: .black),
    AppItem(id: "calc", name: "Калькулятор", sfSymbol: "plus.forwardslash.minus", color: .orange),
    AppItem(id: "vm", name: "Диктофон", sfSymbol: "mic.fill", color: .black),
    AppItem(id: "trn", name: "Переводчик", sfSymbol: "character.bubble.fill", color: .blue),
    AppItem(id: "fit", name: "Фитнес", sfSymbol: "figure.run", color: .black),
    AppItem(id: "hm", name: "Дом", sfSymbol: "house.fill", color: .orange)
]

class ScreenState: ObservableObject {
    @Published var unlocked: Bool = false
    @Published var openApps: [String] = []
    
    func openApp(_ id: String) {
        if let idx = openApps.firstIndex(of: id) {
            openApps.remove(at: idx)
        }
        openApps.append(id)
        if openApps.count > 1 {
            openApps.removeFirst()
        }
    }
    
    func closeApp(_ id: String) {
        openApps.removeAll { $0 == id }
    }
    
    func closeAll() {
        openApps.removeAll()
    }
}
