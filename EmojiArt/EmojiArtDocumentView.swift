//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Matheus Henrique on 10/09/21.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservableObject var document: EmojiArtDocument
   
    
    var body: some View {
        ScrollView(.horizontal) {
            VStack{
                HStack{
                    ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
                        Text(emoji)
                            .font(Font.system(size: self.defaultEmojiSize))
                            .onDrag{ return NSItemProvider(object: emoji as NSString) }
                    }
                }
            }
            .padding(.horizontal)
            GeometryReader {geometry in
                ZStack{
                    Color.white.overlay(
                        Group {
                        if self.document.backgroundImage != nil {
                         Image(uiImage:self.document.backgroundImage!)
                        }
                    }
                )
                
               .edgesIgnoringSafeArea([.horizontal, .bottom])
               .onDrop(of: ["public.image","public.text"], isTargeted: nil) { providers, location in
                var location = geometry.convert(location, from: .global)
                location = CGPoint(x: location.x - geometry.size.width/2, y: location.y - geometry.size.height/2)
                    return self.drop(providers: providers)
                    }
                    ForEach(self.document.emojis) { emoji in
                        Text(emoji)
                            .font(self.font(for: emoji))
                            .position(self.position(for: emoji, in: geometry.size))
                    }
                }
            }
        }
    }
    
    private func font(for emoji: EmojiArt.Emoji) -> Font {
        Font.system(size: emoji.fontSize)
    }
    private func position (for emoji: EmojiArt.Emoji, in size:CGSize) ->CGFloat {
        CGFloat(x: emoji.location.x + size.width/2, y: emoji.location.y + size.height/2)
    }
    
    
    private func drop(providers: [NSItemProvider]) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            self.document.setBackgroundURL(url)
        }
        if !found {
            found = providers.loadObject(ofType: String.self) { String in
                self.document.addEmoji(string, at: location, size: self.defaultEmojiSize)
            }
            
        }
            return found
            
    }
    
    private let defaultEmojiSize: CGFloat = 40
    
}
