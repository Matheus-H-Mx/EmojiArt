//
//  EmojiArtDocumentChooser.swift
//  EmojiArt
//
//  Created by Matheus Henrique on 27/10/21.
//

import SwiftUI

struct EmojiArtDocumentChooser: View {
    @EnvironmentObject var store: EmojiArtDocumentStore
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
        List {
        ForEach(store.documents) { document in
            NavigationLink(destination: EmojiArtDocumentView(document: document)
            .navigationBarTitle(self.store.name(for: document))
            ) {
                EditableText(self.store.name(for: document), isEditing: self.editMode.isEditing){ name in
                    self.store.setName(name, for: document)
                        }
                    }
                }
            
        .onDelete { IndexSet in
            IndexSet.map { self.store.documents[$0] }.forEach {document in
                self.store.removeDocument(document)
                }
            }
        }
        .environment(\.editMode, $editMode)
        .navigationBarTitle(self.store.name)
        .navigationBarItems(leading: Button(action: {
            self.store.addDocument()
        }, label: {
            Image(systemName: "plus").imageScale(.large)
        }),
            trailing: EditButton()
            )
        }
    }
}

struct EmojiArtDocumentChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiArtDocumentChooser()
    }
}
