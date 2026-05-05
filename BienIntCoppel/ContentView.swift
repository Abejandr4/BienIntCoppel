import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                // MARK: - Home Tab
                MainView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                    .tag(0)
                
                // MARK: - Comunidad Tab
                ComunidadView()
                    .tabItem {
                        Label("Comunidad", systemImage: "person.2.fill")
                    }
                    .tag(1)
                
                // MARK: - Preguntas Tab
                PreguntasView()
                    .tabItem {
                        Label("Preguntas", systemImage: "bubble.left.fill")
                    }
                    .tag(2)
                
                // MARK: - Ajustes Tab
                AjustesView()
                    .tabItem {
                        Label("Ajustes", systemImage: "gearshape.fill")
                    }
                    .tag(3)
            }
            .accentColor(.orange) // Matches the highlight color in your image
        }
    }
}

// Ensure your existing MainView is in the same project!
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
