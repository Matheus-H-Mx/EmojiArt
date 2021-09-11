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
                    }
                }
            }
            .padding(.horizontal)
            Rectangle().foregroundColor(.white).overlay(Image(self.document.backgroundImage))
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                .onDrop(of: ["public.image"], isTargeted: nil) { providers, location in
                    return self.drop(providers: providers)
                }
        }
    }
    private func drop(providers: [NSItemProvider]) -> Bool {
        let found = providers.loadFirstObject(oftype: URL.self){
            url in print("dropped \(url)")
            self.document.setBackgroundURL(url)
        }
        return found
    }
    
    
    
    
    private let defaultEmojiSize: CGFloat = 40
}
