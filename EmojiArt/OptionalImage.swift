//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by Matheus Henrique on 23/09/21.
//

import SwiftUI

struct OptionalImage: View {
    var uiImage : UIImage?
        
        var body:some View{
            Group {
                if uiImage != nil {
                    Image(uiImage: uiImage!)//.resizable()
                }
            }
        }
}
