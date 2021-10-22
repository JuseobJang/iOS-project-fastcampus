//
//  ContentDetailView.swift
//  NetfilxStApp
//
//  Created by seob_jj on 2021/10/22.
//

import SwiftUI

struct ContentDetailView: View {
    @State var item: Item?
    
    var body: some View {
        VStack{
            if let item = item {
                Image(uiImage: item.image)
                    .aspectRatio(contentMode: .fit)
                
                Text(item.description)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
                
            } else {
                Color.white
            }
            
        }
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let item0 = Item(description: "룰루랄라", imageName: "poster0")
        
        ContentDetailView(item: item0)
    }
}
