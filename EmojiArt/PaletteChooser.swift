//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Matheus Henrique on 19/10/21.
//

import SwiftUI

struct PalleteChooser: View {
    var body: some View {
        HStack{
            Stepper(onIncrement: {}, onDecrement: {}, label: {Text("Choose Palette" )} )
            Text("Pallete Name")
        }
    }
}

struct PalleteChooser_Previews: PreviewProvider {
    static var previews: some View {
        PalleteChooser()
    }
}
