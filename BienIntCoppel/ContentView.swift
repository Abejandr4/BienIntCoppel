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
                AjustessView()
                    .tabItem {
                        Label("Ajustes", systemImage: "gearshape.fill")
                    }
                    .tag(3)
            }
            .accentColor(.orange) // Matches the highlight color in your image
        }
    }
}

// MARK: - Placeholder Views
// These are placeholders so the code compiles. You can replace them with your actual files.

struct ComunidadView: View {
    var body: some View {
        Text("Comunidad View")
            .font(.title)
    }
}

struct PreguntasView: View {
    var body: some View {
        Text("Preguntas View")
            .font(.title)
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Ajustes View")
            .font(.title)
    }
}

// Ensure your existing MainView is in the same project!
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
