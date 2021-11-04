//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Matheus Henrique on 10/09/21.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject, Hashable, Identifiable {
    
    let id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)  // only works for classes; we'd have to do all variables for structs
    }
    
    static func == (lhs: EmojiArtDocument, rhs: EmojiArtDocument) -> Bool {
        lhs.id == rhs.id    // only works for classes because they're not copied on each pass
    }
    
    // Static so that it is not specific to class instances
    // Eventually will be an array of palettes and be a var
    static let palette: String = "🍎😀😎🐵⚔️📍"
    
    // Don't need the workaround for @Published swift problems, now fixed in newest Swift
    // But changed to follow Lecture 9 publisher.  Commented version worked in newest swift
    @Published private var emojiArt: EmojiArt //= EmojiArt() {
//        didSet {
//            // print("json = \(emojiArt.json?.utf8 ?? "nil")")  // testing only
//            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
//        }
//    }
    
    // Added for cancellable and publishing events
    private var autosaveCancellable: AnyCancellable?
    
    init(id: UUID? = nil) {
        self.id = id ?? UUID()
        let defaultsKey = "EmojiArtDocument.\(self.id.uuidString)"
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: defaultsKey)) ?? EmojiArt()
        autosaveCancellable = $emojiArt.sink { emojiArt in
            //print("json = \(emojiArt.json?.utf8 ?? "nil")")  // testing only
            UserDefaults.standard.set(emojiArt.json, forKey: defaultsKey)
        }
        fetchBackgroundImageData()
    }
    
    // Published so that when it changes, the view redraws
    @Published private(set) var backgroundImage: UIImage?
    
    @Published var steadyStatePanOffset: CGSize = .zero
    @Published var steadyStateZoomScale: CGFloat = 1.0
    
    
    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }
    
    // MARK: - Intent(s)
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    // Homework 4 Required Task 10
    func removeEmoji(_ emoji: EmojiArt.Emoji) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis.remove(at: index)
        }
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }
    
    var backgroundURL: URL? {
        get {
            emojiArt.backgroundURL
        }
        set {
            emojiArt.backgroundURL = newValue?.imageURL
            fetchBackgroundImageData()
        }
    }
    
    private var fetchImageCancellable: AnyCancellable?
    
        private func fetchBackgroundImageData() {
            backgroundImage = nil
            if let url = self.emojiArt.backgroundURL {
                fetchImageCancellable?.cancel()
                fetchImageCancellable? = URLSession.shared.dataTaskPublisher(for: url)
                    .map { data, urlResponse in UIImage(data: data) }
                    .receive(on: DispatchQueue.main)
                    .replaceError(with: nil)
                    .assign(to: \.backgroundImage, on: self)
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat {CGFloat(self.size)}
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y))}
}
