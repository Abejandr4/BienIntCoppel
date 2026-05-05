import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        // Eliminamos el NavigationStack externo para evitar conflictos de doble barra
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
                .accentColor(.orange)// Matches the highlight color in your image
            }
            .accentColor(.orange)
        }
    }
        
        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
    }

