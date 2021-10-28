//
//  HomeViewController.swift
//  NetfilxStApp
//
//  Created by seob_jj on 2021/10/16.
//

import UIKit
import SwiftUI

class HomeViewController: UICollectionViewController {
    
    var contents: [Content] = []
    var mainItem: Item?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //네비게이션 설정
        
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.hidesBarsOnSwipe = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "netflix_icon"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        
        collectionView.backgroundColor = .black
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
        collectionView.register(ContentCollectionViewRankCell.self, forCellWithReuseIdentifier: "ContentCollectionViewRankCell")
        collectionView.register(ContentCollectionViewMainCell.self, forCellWithReuseIdentifier: "ContentCollectionViewMainCell")
        collectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentCollectionViewHeader")

        // data 설정 및 가져오기
        contents = getContetns()
        mainItem = contents.first?.contentItem.randomElement()
        
        collectionView.collectionViewLayout = layout()
        
    }
    
    func getContetns() -> [Content] {
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"),
              let data = FileManager.default.contents(atPath: path),
              let list = try? PropertyListDecoder().decode([Content].self, from: data) else { return [] }
        
        return list
    }
    
    // 각 섹션 타입에 대한 UICollectionViewLayout 생성
    private func layout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] sectionNumber, environment -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            switch self.contents[sectionNumber].sectionType {
            case .basic:
                return self.createBasicTypeSection()
            case .large:
                return self.createLargeTypeSection()
            case .rank:
                return self.createRankTypeSection()
            case .main:
                return self.createMainTypeSection()
            }
            
        }
    }
    
    private func createBasicTypeSection() -> NSCollectionLayoutSection {
        // item
        let itemSIze = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSIze)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let sectionHeader = self.createSectionHeader()
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createLargeTypeSection() -> NSCollectionLayoutSection {
        // item
        let itemSIze = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.75))
        let item = NSCollectionLayoutItem(layoutSize: itemSIze)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(400))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        let sectionHeader = self.createSectionHeader()
        sectionHeader.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
        
    }
    
    private func createRankTypeSection() -> NSCollectionLayoutSection {
        // item
        let itemSIze = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(0.9))
        let item = NSCollectionLayoutItem(layoutSize: itemSIze)
        item.contentInsets = .init(top: 10, leading: 5, bottom: 0, trailing: 5)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let sectionHeader = self.createSectionHeader()
        sectionHeader.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
        
    }
    
    
    private func createMainTypeSection() -> NSCollectionLayoutSection {
        // item
        let itemSIze = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSIze)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(450))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        return section
        
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        // item
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(30))
        
        // section
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
    }
}


// UICollectionView DataSource , Delegate
extension HomeViewController {
    // 섹션당 보여질 셀의 갯수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return contents[section].contentItem.count
        }
    }
    // 콜렉션뷰 셀 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.section].sectionType {
        case .basic, .large:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell() }
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            return cell
        case .rank:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewRankCell", for: indexPath) as? ContentCollectionViewRankCell else { return UICollectionViewCell() }
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            cell.rankLabel.text = String(describing: indexPath.row + 1)
            return cell
        case .main:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewMainCell", for: indexPath) as? ContentCollectionViewMainCell else { return UICollectionViewCell() }
            cell.imageView.image = mainItem?.image
            cell.descriptionLabel.text = mainItem?.description
            return cell
        }
    }
    
    // 헤더 뷰 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentCollectionViewHeader", for: indexPath) as? ContentCollectionViewHeader else { fatalError("Could not dequeue header") }
            headerView.sectionNameLabel.text = contents[indexPath.section].sectionName
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    // 섹션의 갯수
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
    
    // 셀 선택
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let sectionName = contents[indexPath.section].sectionName
//        print("TEST : \(sectionName)섹션의 \(indexPath.row + 1)번째 콘텐츠")
        let isFirstSection = indexPath.section == 0
        let selectedItem = isFirstSection ? mainItem : contents[indexPath.section].contentItem[indexPath.row]
        
        let contentDetailView = ContentDetailView(item: selectedItem)
        let hostingVC = UIHostingController(rootView: contentDetailView)
        self.show(hostingVC,sender: nil)
    }
}


//SwiftUI를 활용한 미리보기
struct HomeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        HomeViewControllerRepresentable().edgesIgnoringSafeArea(.all)
    }
}

struct HomeViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let layout = UICollectionViewLayout()
        let homeViewController = HomeViewController(collectionViewLayout: layout)
        return UINavigationController(rootViewController: homeViewController)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    typealias UIViewControllerType = UIViewController
}
