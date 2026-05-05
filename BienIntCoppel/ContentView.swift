import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        // Eliminamos el NavigationStack externo para evitar conflictos de doble barra
        TabView(selection: $selectedTab) {
            // MARK: - Home Tab
            MainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
            // MARK: - Comunidad Tab
            ComunidadView()
                .tabItem {
                    Image(systemName: "person.2")
                    Text("Comunidad")
                }
                .tag(1)
            
            // MARK: - Preguntas Tab
            PreguntasView()
                .tabItem {
                    Label("Preguntas", systemImage: "bubble.left")
                }
                .tag(2)
            
            // MARK: - Ajustes Tab
            AjustesView()
                .tabItem {
                    Label("Ajustes", systemImage: "gearshape")
                }
                .tag(3)
        }
        .accentColor(.orange)
    }
        

    }

#Preview {
    ContentView()
        .environmentObject(AppState())
}
