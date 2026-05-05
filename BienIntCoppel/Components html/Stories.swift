
import SwiftUI

// 1. Data Model
struct Story: Identifiable {
    let id = UUID()
    let name: String
    let img: String
    var isUser: Bool = false
}

struct StoriesView: View {
    // 2. Mock Data
    let stories = [
        Story(name: "Tu historia", img: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=80&h=80&fit=crop", isUser: true),
        Story(name: "Ana R.", img: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&h=80&fit=crop"),
        Story(name: "Carlos M.", img: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&h=80&fit=crop"),
        Story(name: "María L.", img: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&h=80&fit=crop"),
        Story(name: "José P.", img: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=80&h=80&fit=crop"),
        Story(name: "Laura G.", img: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=80&h=80&fit=crop")
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(stories) { story in
                    StoryItem(story: story)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
        .padding(.top, 8)
    }
}

// 3. Subview for individual Story circle
struct StoryItem: View {
    let story: Story
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack(alignment: .bottomTrailing) {
                // The Border Ring
                Group {
                    if story.isUser {
                        Circle()
                            .strokeBorder(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [4]))
                    } else {
                        Circle()
                            .fill(LinearGradient(
                                colors: [.orange, .emerald],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                    }
                }
                .frame(width: 64, height: 64)
                
                // The Profile Image
                AsyncImage(url: URL(string: story.img)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 58, height: 58)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white, lineWidth: story.isUser ? 0 : 2)
                )
                // Center the image within the ring
                .frame(width: 64, height: 64)
                
                // Plus Button for User Story
                if story.isUser {
                    Image(systemName: "plus")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(Color.blue) // Assuming primary color is blue
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: 2, y: 2)
                }
            }
            
            // Name Label
            Text(story.name)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .frame(maxWidth: 60)
                .lineLimit(1)
        }
    }
}

// Preview
struct StoriesView_Previews: PreviewProvider {
    static var previews: some View {
        StoriesView()
    }
}
