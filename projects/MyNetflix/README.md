# My Netfilx App

**URLSession, GCD(Dispatch Queue) 및 Firebase 연동을 통한 검색어 저장이 가능한 영화 예고편 검색 앱**

<p align="center"> 
  <img width="250" alt="netflix1" src="https://user-images.githubusercontent.com/22047374/128481237-2cc3c5ee-8d18-4a79-9e0d-6d10ae1234f9.png">
	<img width="250" alt="netflix2" src="https://user-images.githubusercontent.com/22047374/128481259-30b05209-ef76-4c7d-adfe-f3b2405ee5e6.png">
  <img width="250" alt="netflix3" src="https://user-images.githubusercontent.com/22047374/128481269-6e7a71bb-4e08-4264-a480-465dbf981185.png">
</p> 
## Storyboard Review

### Main.storyboard

#### Scroll View 사용하기

1. Scroll View : Constraints를 화면에 딱 맞추어 설정(leading, trailing, top, bottom)
2. Content View : 
   1. 스크롤 뷰 내부에 위치
   2. Width 와 Height 는 스크롤 뷰를 감싸는 화면과 같게 설정 (아래로 스크롤 이기 때문에 Height priority 줄이기)
   3. Constraints는 스크롤뷰에 딱 맞게 설정

#### Nested Scroll View 사용하기

1. 스택뷰 내에 컨테이너 뷰들 위치
2. 컨테이너 뷰 각각에 뷰컨트롤러 embed in 시켜주기
3. 컨테이너 뷰에 연결된 뷰컨트롤러 내에 Scroll Direction이 Horizontal 인 콜렉션 뷰 위치
4. 컨테이너뷰와 뷰컨트롤러를 이어주는 세그에 Identifier 설정하기



> **스토리보드 뷰컨트롤러 사이즈 변경**
> View Controller 의 size inspector 에서 Simulated Size: freedom 으로 변경



영화 검색 화면은 Collection View 와 Search Bar를 사용하여 구성

지난 검색어  화면은 Table View를 사용하여 구성



### Player.storyboard

1. 플레이되는 영상이 보이는 플레이어뷰를 화면에 크기에 맞춰서 위치
2. 해당 영상을 컨트롤 하기위한 컨트롤 뷰를 플레이어뷰와 같은 크기로 맞춰서 위치
3. 컨트롤 뷰 위에 재생/정지를 위한 버튼 위치



## Code Review

### HomeViewController.swift

홈화면 스택뷰 내부의 컨테이너뷰와 연결된 뷰컨트롤러들 세그를 이용하여 연결

```swift
// 세가지 뷰컨트롤러 
var awardRecommendListViewController: RecommendListViewController!
var hotRecommendListViewController: RecommendListViewController!
var myRecommendListViewController: RecommendListViewController!
```

```swift
// 스토리보드에서 지정한 세그의 Identifier를 이용하여 각 뷰컨트롤러와 들어갈 데이터를 구분
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  if segue.identifier == "award" {
    let destinationVC = segue.destination as? RecommendListViewController
    awardRecommendListViewController = destinationVC
    awardRecommendListViewController.viewModel.updateType(.award)
    awardRecommendListViewController.viewModel.fetchItems()
  } else if segue.identifier == "hot" {
    let destinationVC = segue.destination as? RecommendListViewController
    hotRecommendListViewController = destinationVC
    hotRecommendListViewController.viewModel.updateType(.hot)
    hotRecommendListViewController.viewModel.fetchItems()
  } else if segue.identifier == "my" {
    let destinationVC = segue.destination as? RecommendListViewController
    myRecommendListViewController = destinationVC
    myRecommendListViewController.viewModel.updateType(.my)
    myRecommendListViewController.viewModel.fetchItems()
  }
}
```

홈화면의 재생버튼 클릭 처리

```swift
@IBAction func playButtonTapped(_ sender: Any) {
  // 인터스텔라에 대한 정보를 검색 API로 가져온다
  // completion 정의 
  SearchApi.search("interstella"){ movies in 
                                  guard let interstella = movies.first else {
                                    print("Failed search interstella")
                                    return }
																	// UI Update는 메인쓰레드에서 실행
                                  DispatchQueue.main.async {
                                    // 인터스텔라의 url을 가져와 AVPlayerItem으로 만듬
                                    let url = URL(string: interstella.previewURL)!
                                    let item = AVPlayerItem(url: url)
                                    
                                    // Player 뷰컨트롤러를 가져옴
                                    let sb = UIStoryboard(name: "Player", bundle: nil)
                                    let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController

																		// 해당 AVPlayerItem으로 플레이어의 아이템을 교체 및 화면을 풀스크린으로 띄움
                                    vc.player.replaceCurrentItem(with: item)
                                    vc.modalPresentationStyle = .fullScreen
                                    self.present(vc, animated: false, completion: nil)
                                  }
                                 }

}
```



### PlayerViewController.swift

#### Override Function

supportedInterfaceOrientations( ) : 기본 오리엔테이션(화면 방향) 설정

```swift
override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
// 오른방향 랜드스케이프로 설정
  return .landscapeRight
}
```

viewDidLoad( ) : 뷰가 로딩되고 난 후

```swift
override func viewDidLoad() {
  super.viewDidLoad()
  // 플레이어뷰의 플레이어를 currentItem이 변경된 현재 player로 대체한다.
  playerView.player = player 
}
```

viewWillAppear( ) : 뷰가 보여지기 직전

```swift
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
  // 영상 실행
  play()
}
```



#### @IBAction

togglePlayButton( ) : 컨트롤뷰의 플레이버튼 클릭

```swift
@IBAction func togglePlayButton(_ sender: Any) {
// 재생중이면 정지 또는 정지중이면 재생
  if player.isPlaying {
    pause()
  }else{
    play()
  }
}
```

closeButtonTapped( ) : 나가기 버튼 클릭

```swift
@IBAction func closeButtonTapped(_ sender: Any) {
  // player item 리셋하기
  reset()
  // 해당 뷰컨트롤러 나가기
  dismiss(animated: false, completion: nil)
}
```



#### Methods

```swift
// 플레이어 실행 
func play(){
  player.play()
  playButton.isSelected = true
}

// 플레이어 정지
func pause(){
  player.pause()
  playButton.isSelected = false
}

// 플레이어 아이템 삭제
func reset(){
  player.replaceCurrentItem(with: nil)
}
```



#### Extension AVPlayer

```swift
// 현재 플레이 중인지 확인하기 위한 속성 추가, 현재 아이템이 없으면 rate 를 0으로 설정(정지)
extension AVPlayer {
  var isPlaying: Bool {
    guard self.currentItem != nil else { return false }
    return self.rate != 0
  }
}
```



### SearchViewController.swift

검색기록을 저장하기위한 파이어베이스 데이터베이스와 검색 결과를 담기위한 배열

```swift
let db = Database.database().reference().child("searchHistory")
var movies: [Movie] = []
```



#### Protocols

##### 컬렉션뷰 관련 프로토콜 

1. UICollectionViewDataSource

```swift
// 콜렉션뷰에 표현될 아이템의 갯수
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  return movies.count
}
```

```swift
// 콜렉션뷰셀에 어떻게 표현할지 정의
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else {
    return UICollectionViewCell()
  }

  // imagePath(String)을 image로 만들기
  // 3rd party library; King Fisher 를 사용하여 이미지 렌더링
  let movie = movies[indexPath.item]
  let url = URL(string: movie.thumbnailPath)!
  cell.movieThumbnail.kf.setImage(with: url)
  return cell
}
```

2. UICollectionViewDelegate

```swift
// 콜렉션 뷰 셀 터치시 이벤트 처리
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  // 검색결과 중 indexPath.item에 해당하는 영화 가져오기
  let movie = movies[indexPath.item]
  // 해당 영화의 프리뷰 url을 사용하여 AVPlayerItem으로 만들기
  let url = URL(string: movie.previewURL)!
  let item = AVPlayerItem(url: url)
  
	// Player Storyboard에서 Player View Controller를 가져옴
  let sb = UIStoryboard(name:"Player",bundle: nil)
  let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
  vc.modalPresentationStyle = .fullScreen

  // 해당 뷰컨트롤러의 플레이어의 아이템을 현재 아이템으로 대체 해주고 present함
  vc.player.replaceCurrentItem(with: item)
  present(vc, animated: false, completion: nil)
}
```

3. UICollectionViewDelegateFlowLayout

```swift
// 콜렉션 뷰 셀의 크기 정의
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

  let margin: CGFloat = 8
  let itemSpacing: CGFloat = 10
  let width = (collectionView.bounds.width - margin * 2 - itemSpacing * 2)/3
  let height = width * 10/7
  return CGSize(width: width, height: height)
}
```



##### 서치바 관련 프로토콜

UISearchBarDelegate

```swift
// 검색 버튼 클릭 시 
func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

  // 키보드가 올라와 있을 때, 내려가게 처리
  dismissKeyboard()

  // 검색어가 있는 지 확인
  guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else {
    return
  }

  // 네트워킹을 통한 검색
  // - 서치텀을 가지고 네트워킹을 통해서 영화검색
  // - 검색 API  필요
  // - 결과를 받아올 모델 Movie, Response
  // - 결과를 받아와서 CollectionView에 표현
  SearchApi.search(searchTerm){ movies in
                               // timestamp를 구함
                               let timestamp = Date().timeIntervalSince1970.rounded()
                               // 검색어와 타임스탬프를 묶어서 파이어베이스 데이터베이스에 저장
                               self.db.childByAutoId().setValue(["term": searchTerm, "timestamp": timestamp])
                               // UI update는 매인 스레드에서 실행
                               DispatchQueue.main.async {
                                 self.movies = movies
                                 self.resultCollectionView.reloadData()
                               }
                              }
}

private func dismissKeyboard(){
  searchBar.resignFirstResponder()
}
```



#### SearchAPI Class

```swift
class SearchApi{
  // 타입 메서드로 search() 정의
  static func search(_ term: String, completion: @escaping ([Movie]) -> Void){
    // URLSession 가져오기
    let session = URLSession(configuration: .default)
    // Base URL 설정
    var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
    // 쿼리문 설정
    let mediaQuery = URLQueryItem(name: "media", value: "movie")
    let entityQuery = URLQueryItem(name: "entity", value: "movie")
    let termQuery = URLQueryItem(name: "term", value: term)

    urlComponents.queryItems?.append(mediaQuery)
    urlComponents.queryItems?.append(entityQuery)
    urlComponents.queryItems?.append(termQuery)

    // requestURL로 변환
    let requestURL = urlComponents.url!

    // requestURL을 사용하여 데이터 요청 
    let dataTask = session.dataTask(with: requestURL){ data, response, error in
                                                      let successRange = 200..<300
                                                      guard error == nil,
                                                      let statusCode = (response as? HTTPURLResponse)?.statusCode,
                                                      successRange.contains(statusCode) else {
                                                        completion([])
                                                        return
                                                      }

                                                      guard let resultData = data else {
                                                        completion([])
                                                        return
                                                      }
                                                      let movies = parseMovies(resultData)
                                                      completion(movies)
                                                     }
    dataTask.resume()
  }

  // response로 부터 받은 데이터를 JSONDecoder를 사용하여 Movie 배열로 파싱하여줌
  static func parseMovies(_ data: Data) -> [Movie] {
    let decoder = JSONDecoder()

    do {
      let response = try decoder.decode(Response.self, from: data)
      let movies = response.movies
      return movies
    } catch let error {
      print("---> parsing error: \(error.localizedDescription)")
      return []
    }
  }
}
```



#### Codable Structure

1. Response structure

```swift
struct Response: Codable {
  let resultCount: Int
  let movies: [Movie]

  // Json의 키값과 매칭 시켜줌
  enum CodingKeys: String, CodingKey {
    case resultCount
    case movies = "results" 
  }
}
```

2. Movie structure

```swift
struct Movie: Codable {
  let title: String
  let director: String
  let thumbnailPath: String
  let previewURL: String

  enum CodingKeys: String, CodingKey {
    case title = "trackName"
    case director = "artistName"
    case thumbnailPath = "artworkUrl100"
    case previewURL = "previewUrl"
  }
}
```



### HistoryViewController.swift

검색기록을 저장해놓은 파이어베이스 데이터베이스와 검색 기록을 저장하기 위한 배열

```swift
let db = Database.database().reference().child("searchHistory")
var searchTerms: [SearchTerm] = []
```



#### override func ViewWillAppear() 

```swift
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
  // 서버의 데이터베이스로 부터 검색기록을 가져옴
  db.observeSingleEvent(of: .value){ snapshot in
                                    // 데이터들을 [String: Any] 딕셔너리로 타입 캐스팅
                                    guard let searchHistory = snapshot.value as? [String: Any] else { return }
                                    // JSON 형식의 데이터로 변환
                                    let data = try! JSONSerialization.data(withJSONObject: Array(searchHistory.values), options: [])
                                    // JSONDecoder를 사용하여 파싱
                                    let decoder = JSONDecoder()
                                    let searchTerms = try! decoder.decode([SearchTerm].self, from: data)
                                    // 해당 term들을 timestamp순으로 정렬하여 저장
                                    self.searchTerms = searchTerms.sorted{ (term1, term2) in
                                                                          return term1.timestamp > term2.timestamp }
                                    // 테이블뷰 리로딩	
                                    self.tableView.reloadData()
                                   }
}

```









