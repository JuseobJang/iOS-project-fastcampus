# Bounty List App

**콜렉션 뷰와 세그를 이용한 화면 전환 그리고 애니메이션을 이용한 현상금 앱**

<p align="center"> 
  <img width="250" alt="Bounty1" src="https://user-images.githubusercontent.com/22047374/128479790-ee823f55-a308-42db-bc6c-524d234af6f8.png">
	<img width="250" alt="Bounty2" src="https://user-images.githubusercontent.com/22047374/128479780-86d5eba8-3321-4344-aadc-963a2dbe6857.png">
</p> 

## Stortboard Review

### Main.storyboard

#### Bounty View Controller

- Collection View

  콜렉션 뷰를 View Controller에 배치 시킨 후 오토 레이아웃 적용 및 dataSources & delegate 를 outlet으로 연결 시켰다.

  

- Collection View Cell

  - "GridCell" 이라는 Identifer를 적용 시켜 View Controller 코드 내에서 커스텀 할 수 있도록 한다.
  - Cell 내부에 ImageView, Label 등을 오토레이아웃을 적용 시켜 배치 



#### Detail View Controller

Bounty View Controller 와 Present Modally (kind) 로 Segue를 연결 하여 Cell 선택시 Detail View Controller가 표시 될수 있도록한다.



## Code Review

### BountyViewController.swift

#### ViewModel

MVVM 패턴의 view model 을 사용하여 BountyInfo 에 접근

```swift
let viewModel = BountyViewModel()
```

class BountyViewModel

```Swift
class BountyViewModel {
  let bountyInfoList : [BountyInfo] = [
    BountyInfo(name: "brook", bounty: 33000000),
    BountyInfo(name: "chopper", bounty: 50),
    BountyInfo(name: "franky", bounty: 44000000),
    BountyInfo(name: "luffy", bounty: 300000000),
    BountyInfo(name: "nami", bounty: 16000000),
    BountyInfo(name: "robin", bounty: 80000000),
    BountyInfo(name: "sanji", bounty: 77000000),
    BountyInfo(name: "zoro", bounty: 120000000),
  ]

  // bountyInfoList 정렬한 computed value
  var sortedList: [BountyInfo] {
    let sortedList = bountyInfoList.sorted { prev, next in
                                            return prev.bounty > next.bounty
                                           }
    return sortedList
  }

  // bountyInfoList 내 원소 갯수 반환
  var numOfBountyInfoList: Int {
    return bountyInfoList.count
  }

  // sortedList 에서 index에 해당하는 BountyInfo 반환
  func bountyInfo(at index: Int) -> BountyInfo {
    return sortedList[index]
  }
}
```

struct BountyInfo

```swift
struct BountyInfo {
  let name: String // 이름
  let bounty: Int // 현상금

  // 이미지는 name.jpg 형식으로 asset에 저장되어 있는 이미지를 불러옴
  var image: UIImage? {
    return UIImage(named: "\(name).jpg")
  }
	// initializer
  init(name: String, bounty: Int){
    self.name = name
    self.bounty = bounty
  }
}
```



#### Protocol 

UICollectionViewDataSource protocol

1. 데이터의 갯수가 몇개인지

```swift
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  return viewModel.numOfBountyInfoList
}
```

2. 셀을 어떻게 표현할지

```swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  // 스토리 보드에서 설정한 Identifier를 사용하여 cell을 불러온 후 커스텀한 GridCell로 타입 캐스팅을 한다.
  guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath)as? GridCell else {
    return UICollectionViewCell()
  }

  // bountyInfo를 가져와 cell을 업데이트 해준다.
  let bountyInfo = viewModel.bountyInfo(at: indexPath.item)
  cell.update(info: bountyInfo)
  return cell
}
```



UICollectionViewDelegate protocol

1. 셀이 클릭 되었을 때 어떻게 처리 할 것인지

```swift
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  print("--> \(indexPath.item)")
  // storyboard에서 설정해 놓은 identifer를 이용하여 segue를 수행 sender에 indexPath.item을 담아 보내준다.
  performSegue(withIdentifier: "showDetail", sender: indexPath.item)
}
```



UICollectionViewDelegateFlowLayout

1. 셀의 사이즈 계산

```swift
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  let itemSpacing: CGFloat = 10 // item 간의 공간은 10으로 고정
  let textAreaHeight: CGFloat = 65 // 이름과 현상금이 표시될 공간의 height

  let width: CGFloat = (collectionView.bounds.width - itemSpacing)/2 //collectionView의 전체 width에서 사이 공간을 제외하고 절반으로 나눈값이 cell의 width
  let height: CGFloat = width * (10/7) + textAreaHeight // 이미지의 가로세로 비율을 10 : 7 로 설정하고 아래 공간의 높이를 더한다.
  return CGSize(width: width, height: height)
}
```



#### override prepare() 

performSegue()가 실행 후에 실행되는 함수

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  if segue.identifier == "showDetail" {
    // segue 목적지인 DetailViewController를 불러옴
    let vc = segue.destination as? DetailViewController 
		// perfotmSegue()시에 indexPath.item을 sender로 넘겼기 때문에 타입 캐스팅을 해준다.
    if let index = sender as? Int {
      // 해당 index를 이용하여 bountyInfo를 가져옴
      let bountyInfo = viewModel.bountyInfo(at: index)
      // DetailViewController 의 viewModel을 업데이트 해줌
      vc?.viewModel.update(model: bountyInfo)
    }
  }
}
```



### DetailViewController.swift

#### View Model

마찬가지로 Detail View Controller 에서 사용하는 View Model을 따로 정의하여 사용한다.

```swift
let viewModel = DetailViewModel()
```

Class DetailViewModel

```swift
class DetailViewModel{
  var bountyInfo: BountyInfo?

  func update(model: BountyInfo){
    bountyInfo = model
  }
}
```



#### override func viewDidLoad()

뷰가 로딩 되면 UI를 업데이트 해주고 애니메이션을 준비한다.

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  updateUI()
  prepareAnimation()
}

// 업데이튼된 bountyInfo를 사용하여 각 UI components를 업데이트하여 준다.
func updateUI(){
  if let bountyInfo = self.viewModel.bountyInfo {
    imgView.image = bountyInfo.image
    nameLabel.text = bountyInfo.name
    bountyLabel.text = "\(bountyInfo.bounty)"
  }
}

// 애니메이션이 시작되기 전 위치로 UI components를 이동 시킨다.
func prepareAnimation(){
  // view의 바깥으로 이동 + x 및 y 축 기준 3배씩 늘림 + 180도 회전
  nameLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
  bountyLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)

  nameLabel.alpha = 0
  bountyLabel.alpha = 0
}
```



#### override func ViewDidAppear()

뷰가 화면에 보여진 후 준비된 애니메이션을 동작 시켜준다.

```swift
// 뷰가 보여진 후 
override func viewDidAppear(_ animated: Bool) {
  super.viewDidAppear(animated)
  showAnimation()
}

func showAnimation(){
  // identity 로 transform 이전 속성을 가져와서 원래 속성으로 돌려준다.
  UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
    self.nameLabel.transform = CGAffineTransform.identity
    self.nameLabel.alpha = 1
  }, completion: nil)

  UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2, options: .allowUserInteraction, animations: {
    self.bountyLabel.transform = CGAffineTransform.identity
    self.bountyLabel.alpha = 1
  }, completion: nil)

  UIView.transition(with: imgView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
}
```

