//
//  AssetMenuStyle.swift
//  MyAssets
//
//  Created by seob_jj on 2021/10/28.
//

import SwiftUI

struct AssetMenuStyle: ButtonStyle {
    let menu: AssetMenu
    func makeBody(configuration: Configuration) -> some View {
        return VStack{
            Image(systemName: menu.systemImageName)
                .resizable()
                .frame(width: 30, height: 30)
                .padding([.leading, .trailing], 10)
            Text(menu.title)
                .font(.system(size: 12, weight: .bold))
        }
        .padding()
        .foregroundColor(.blue)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}

struct AssetMenuStyle_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 20) {
            Button(""){
                print("")
            }
            .buttonStyle(AssetMenuStyle(menu: .creditScore))
            Button(""){
                print("")
            }
            .buttonStyle(AssetMenuStyle(menu: .bankAccount))
            Button(""){
                print("")
            }
            .buttonStyle(AssetMenuStyle(menu: .creditCard))
            Button(""){
                print("")
            }
            .buttonStyle(AssetMenuStyle(menu: .cash))
        }
    }
}
