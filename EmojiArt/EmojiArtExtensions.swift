//
//  EmojiArtExtensions.swift
//  EmojiArt
//
//  Created by Matheus Henrique on 10/09/21.
//

import SwiftUI

extension Collection where Element: Identifiable {
    func firstIndex(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
    func firstIndex(matching element: Element) -> Bool {
        self.contains(where: { $0.id == element.id })
        
    }
}

extension URL {
    var imageURL: URL {
        //check imgurl reference
        for query in query?.components(separatedBy: "&") ?? [] {
            let queryComponents = query.components(separatedBy: "=")
                if queryComponents.count == 2 {
                    if queryComponents[0] == "imgurl", let url = URL (string: queryComponents[1].removingPercentEncoding ?? "") {
                        return url
                    }
                }
            }
        return self.baseURL ?? self
        }
    }

extension GeometryProxy {
    func covert(_ point: CGPoint, from coordinateSpace: CoordinateSpace) -> CGPoint {
        let frame = self.frame(in: coordinateSpace)
        return CGPoint(x: point.x-frame.origin.x, y: point.y-frame.origin.y)
    }
}
extension Array where Element == NSItemProvider {
    func loadObject<T>(ofType theType: T.Type, firstOnly: Bool = false, using load: @escaping (T) -> Void) -> Bool where T: NSItemProviderReading {
        if let provinder = self.first(where: {$0.canLoadObject(ofClass: theType) }) {
            provinder.loadObject(ofClass: theType) { object, error in
                if let value = object {
                    DispatchQueue.main.async {
                        load(value)
                    }
                }
            }
        return true
        }
    }
}
