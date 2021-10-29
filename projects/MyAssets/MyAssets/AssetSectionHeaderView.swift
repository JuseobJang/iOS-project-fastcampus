//
//  AssetSectionHeaderView.swift
//  MyAssets
//
//  Created by seob_jj on 2021/10/29.
//

import SwiftUI

struct AssetSectionHeaderView: View {
    let title: String
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.accentColor)
            
            Divider()
                .frame(height: 2)
                .background(Color.primary)
                .foregroundColor(.accentColor)
        }
    }
}

struct AssetSectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        AssetSectionHeaderView(title: "은행")
    }
}
