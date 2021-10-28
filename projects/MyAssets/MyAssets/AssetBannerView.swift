//
//  AssetBannerView.swift
//  MyAssets
//
//  Created by seob_jj on 2021/10/28.
//

import SwiftUI

struct AssetBannerView: View {
    let bannerList: [AssetBanner] =
    [
        AssetBanner(title: "공지사항1", description: "공지사항 1입니다", backgroundColor: .red),
        AssetBanner(title: "공지사항2", description: "공지사항 2입니다", backgroundColor: .blue),
        AssetBanner(title: "공지사항3", description: "공지사항 3입니다", backgroundColor: .green),
        AssetBanner(title: "공지사항4", description: "공지사항 4입니다", backgroundColor: .yellow),
    ]
    @State private var currentPage = 0
    var body: some View {
        let bannerCards = bannerList.map {
            BannerCard(banner: $0)
        }
        ZStack(alignment: .bottomTrailing){
            PageViewController(pages: bannerCards, currentPage: $currentPage)
            PageControl(numberOfPages: bannerList.count, currentPage: $currentPage)
                .frame(width: CGFloat(bannerCards.count * 18))
                .padding(.trailing)
        }
    }
}

struct AssetBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AssetBannerView()
            .aspectRatio(5/2, contentMode: .fit)
    }
}
