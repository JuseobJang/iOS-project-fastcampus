# Apple Music Style App

**AVFoundation 를 이용한 음악 플레이 앱**

<p align="center"> 
  <img width="250" alt="music1" src="https://user-images.githubusercontent.com/22047374/128480465-8a38ca33-0ad5-4dd8-95d8-40778e0aba80.png">
	<img width="250" alt="music2" src="https://user-images.githubusercontent.com/22047374/128480542-fa6b9c6b-e8f8-4729-84ba-b5c688e8f8c7.png">
</p> 

## Storyboard Review

### Main.storyboard

#### Home View Controller

1. 콜렉션 뷰를 화면에 꽉차게 오토레이아웃 적용 및 **dataSource** 와 **delegate** 를 HomeViewConroller를 outlet 연결한다.

2. 콜렉션 뷰 내부에 콜렉션 뷰 헤더와 콜렉션 뷰 셀을 오토레이아웃을 적용 시켜 위치 시킨다.

   - 콜렉션 뷰 헤더
     1. Identifer 를 "TrackCollectionHeaderView" 로 설정
     2. 헤더내의 각 UI Components를 outlet으로 연결 
     3. UIImageView `TouchUpInside` 이벤트 설정
   - 콜렉션 뷰 셀
     1. Identifier를 "TrackCollectionViewCell" 로 설정
     2. 마찬가지로 각 UI Components를 outlet으로 연결 

   

### Player.storyboard

#### Player View Controller

1. Thumbnail, title 그리고 artist 는 Player View Controller와 referencing outlet을 연결 시켜준다.
2. Slider는 referencing outlet을 연결 시켜주고 추가로 `EditingDidBegin`, `EditingDidEnd` 그리고 `valueChanged` 에 대한 이벤트에 대한 처리를 연결해준다.




## Code Review

### Home 

#### HomeViewController.swift

트랙관리를 위한 트랙 매니저 생성

```swift
let trackManager: TrackManager = TrackManager()
```

##### Protocol

1. UICollectionViewDataSource

```swift
extension HomeViewController: UICollectionViewDataSource {
  // 셀을 몇개 표시 할지!
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return trackManager.tracks.count
  }

  // 셀을 어떻게 표현할지!
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // ReuseIdentifier 를 사용해서 cell을 가져와 TrackCollectionViewCell로 타입 캐스팅함
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackCollectionViewCell", for: indexPath) as? TrackCollecionViewCell else {
      return UICollectionViewCell()
    }

    // 트랙매니저를 사용하여 track을 가져오고 해당 트랙을 사용하여 cell의 내용을 업데이트
    let track = trackManager.track(at: indexPath.item)
    cell.updateUI(item: track)

    return cell
  }

  // 헤더뷰 어떻게 표시할지!
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
      // kind(종류)가 UICollectionView.elementKindSectionHeader인 경우
      case UICollectionView.elementKindSectionHeader: 

      // 트랙매니저를 통해서 오늘의 트랙을 가져옴
      guard let item = trackManager.todayTrack else {
        return UICollectionReusableView()
      }

      // ReuseIdentifier를 사용하여 헤더를 가져오고 TrackCollectionHeaderView으로 타입 캐스팅 함
      guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TrackCollectionHeaderView", for: indexPath) as? TrackCollectionHeaderView else {
        return UICollectionReusableView()
      }

      // 가져온 track item을 사용하여 header의 UI를 업데이트 함
      header.update(with: item)

      // 헤더 탭 핸들러 정의 : 
      // playerStoryBoard를 가져온후 그 안에서 PlayerViewController를 가져와 타입 캐스팅 함
      // 그 후 PlayerViewController의 simplePlayer의 아이템을 현재 아이템으로 교체 해준후 present함
      header.tapHandler = { item -> Void in
                           let playerStoryBoard = UIStoryboard.init(name: "Player", bundle: nil)
                           guard let playerVC = playerStoryBoard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController
                           else { return }
                           playerVC.simplePlayer.replaceCurrentItem(with: item)
                           self.present(playerVC, animated: true, completion: nil)
                          }

      return header
      default:
      return UICollectionReusableView()
    }
  }
}
```



2. UICollectionViewDelegate

```swift
extension HomeViewController: UICollectionViewDelegate {
  // 셀을 클릭했을때 어떻게 할지!(헤더의 탭핸들러 설정과 같음)
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let playerStoryBoard = UIStoryboard.init(name: "Player", bundle: nil)
    guard let playerVC = playerStoryBoard.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController
    else { return }

    let item = trackManager.tracks[indexPath.item]
    playerVC.simplePlayer.replaceCurrentItem(with: item)
    present(playerVC, animated: true, completion: nil)

  }
}
```



3. UICollectionViewDelegateFlowLayout

```swift
extension HomeViewController: UICollectionViewDelegateFlowLayout {
  // 셀 사이즈 어떻게 할지!
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemSpacing: CGFloat = 20 
    let margin: CGFloat = 20
    let width = (collectionView.bounds.width - itemSpacing - margin * 2)/2
    let height = width + 60
    return CGSize(width: width, height: height)
  }
}
```



#### TrackCollectionHeaderView.swift

`TrackCollectionHeaderView` 는 `UICollectionReusableView` 를 상속한다.

1. @IBOutlet : 썸네일 `ImageView` 와 설명 `label`

```Swift
@IBOutlet weak var thumbnailImageView: UIImageView!
@IBOutlet weak var descriptionLabel: UILabel!
```

```swift
// item을 이용하여 헤더뷰 UI 업데이트
func update(with item: AVPlayerItem) {
  self.item = item
  // AVFoundation의 AVPlayerItem을 Track struct로 변환
  guard let track = item.convertToTrack() else {return}

  // 이미지 및 텍스트 적용
  self.thumbnailImageView.image = track.artwork
  self.descriptionLabel.text = "Today's pick is \(track.artist)'s album -\(track.albumName), Let's listen!"
}
```

2. item & tapHandler

```swift
var item: AVPlayerItem?
// 핸들러에 대한 정의는 해당 헤더를 사용하는 측에서 정의 함
var tapHandler: ((AVPlayerItem) -> Void)? 
```

```swift
// 헤더를 탭했을 때 item을 가지고 이벤트를 하는 함수
@IBAction func cardTapped(_ sender: UIButton) {
  guard let todayItem = item else { return }
  tapHandler?(todayItem)
}
```



#### TrackCollecionViewCell.swift

`TrackCollecionViewCell` 는 `UICollectionViewCell` 를 상속한다.

```swift
@IBOutlet weak var trackThumbnail: UIImageView!
@IBOutlet weak var trackTitle: UILabel!
@IBOutlet weak var trackArtist: UILabel!
```

```swift
// item(Track Struct)를 사용하여 UI 업데이트 하기!
func updateUI(item: Track?) {
  guard let track = item else { return }
  trackThumbnail.image = track.artwork
  trackTitle.text = track.title
  trackArtist.text = track.artist
}
```



### Player

#### PlayerViewContoller.swift

스토리보드에서 연결한 UI Components

```swift
@IBOutlet weak var thumbnailImageView: UIImageView!
@IBOutlet weak var titleLabel: UILabel!
@IBOutlet weak var artistLabel: UILabel!

@IBOutlet weak var playControlButton: UIButton!
@IBOutlet weak var timeSlider: UISlider!
@IBOutlet weak var currentTimeLabel: UILabel!
@IBOutlet weak var totalDurationLabel: UILabel!
```

음악재생을 위해 필요한 프로퍼티

```swift
// 음악 재생을 위한 SimplePlayer (Singleton으로 생성)
let simplePlayer = SimplePlayer.shared
// 음악 재생 시간변화 관찰을 위한 Observer
var timeObserver: Any?
// 음악 슬라이더를 통해 탐색중인지 아닌지 플래그
var isSeeking: Bool = false
```



##### Override Function

1. viewDidLoad()

```swift
override func viewDidLoad() {
  super.viewDidLoad()

  // 음악재생 여부에 따른 play button UI 변경 : 처음에는 정지 상태 이므로 플레이 버튼이 나와야함
  updatePlayButton()
  
  // 시간을 0 으로 설정
  updateTime(time: CMTime.zero)
  
  // 타입 옵저버 설정 및 simplePlayer에 추가
  timeObserver = simplePlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 10), queue: DispatchQueue.main, using: { time in self.updateTime(time: time)})
}
```

2. viewWillAppear()

```swift
// 뷰가 보이기 직전  및 트랙 정보 변경
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
  //play control button 색 변경
  updateTintColor()
  // 트랙 정보 변경
  updateTrackInfo()
}
```

3. viewWillDisappear()

```swift
// 뷰 나갈때 처리
override func viewWillDisappear(_ animated: Bool) {
  super.viewWillDisappear(animated)
  // 플레이어 정지 
  simplePlayer.pause()
  // 플레이어의 아이템 nil로 교체(삭제)
  simplePlayer.replaceCurrentItem(with: nil)
}
```



##### Slider & Play Control Button @IBAction

```swift
// 드래그 시작시 탐색중 = true
@IBAction func beginDrag(_ sender: UISlider) {
  isSeeking = true
}

// 드래그 종료시 탐색중 = false
@IBAction func endDrag(_ sender: UISlider) {
  isSeeking = false
}

// 슬라이더의 값 변화시 
@IBAction func seek(_ sender: UISlider) {
  // 일단 플레이어에서 현재 트랙 아이템을 가져옴
  guard let currentItem = simplePlayer.currentItem else {
    return
  }
	// 슬라이더의 현재 위치를 가져옴
  let postion = Double(sender.value)
  // 현재 위치를 초로 변환
  let seconds = postion * currentItem.duration.seconds
  // CMTime으로 변환
  let time = CMTime(seconds: seconds, preferredTimescale: 100)
  // 플레이어에서 해당 시간으로 이동
  simplePlayer.seek(to: time)
}
```

```swift
// 플레이버튼 토글 구현
@IBAction func togglePlayButton(_ sender: UIButton) {
  // 현재 플레이 중이면 정지
  if simplePlayer.isPlaying {
    simplePlayer.pause() 
    // 현재 정지중이면 플레이
  } else {
    simplePlayer.play()
  }
  updatePlayButton()
}
```



##### Update Functions

```swift
// 플레이어의 트랙 AVPlayerItem을 Track Struct로 변환 후 해당 정보를 활용하여 UI 업데이트
func updateTrackInfo() {
  guard let track = simplePlayer.currentItem?.convertToTrack() else { return }
  thumbnailImageView.image = track.artwork
  titleLabel.text = track.title
  artistLabel.text = track.artist
}

// 플레이 버튼과 타임 슬라이더 틴트 컬러 변경
func updateTintColor() {
  playControlButton.tintColor = DefaultStyle.Colors.tint
  timeSlider.tintColor = DefaultStyle.Colors.tint
}

// 플레이어를 사용하여 시간 정보 업데이트
func updateTime(time: CMTime) {
  currentTimeLabel.text = secondsToString(sec: simplePlayer.currentTime)   // 3.1234 >> 00:03
  totalDurationLabel.text = secondsToString(sec: simplePlayer.totalDurationTime)  // 39.2045  >> 00:39

  // 노래 들으면서 시킹하면, 자꾸 슬라이더가 업데이트 됨, 따라서 시킹아닐때마 슬라이더 업데이트하자
	// 타입 슬라이더 값 업데이트
  if isSeeking == false {
    timeSlider.value = Float(simplePlayer.currentTime/simplePlayer.totalDurationTime)
  }
}
```



#### SimplePlayer.swift

이 앱내에서 SimplePlayer는 하나만 쓰이면 되기 때문에 싱글톤으로 만듬

```swift
static let shared = SimplePlayer()
```

AVFoundation의 AVPlayer를 사용하여 음악 수행

```swift
// import AVFoundation
private let player = AVPlayer()
```

##### 현재 상태에 관한 메서드

```Swift
// currentTime 구하기
var currentTime: Double {
  return player.currentItem?.currentTime().seconds ?? 0
}

// totalDurationTime 구하기
var totalDurationTime: Double {
  // TODO: totalDurationTime 구하기
  return player.currentItem?.duration.seconds ?? 0
}

// 현재 재생중인지 구하기
var isPlaying: Bool {
  return player.isPlaying
}

// 현재 재생중인 아이템 구하기
var currentItem: AVPlayerItem? {
  return player.currentItem
}
```



##### 동작에 관한 메서드

```swift
// 음악 정지
func pause() {
  player.pause()
}

// 음악 재생
func play() {
  player.play()
}

// 음악 탁색
func seek(to time:CMTime) {
  player.seek(to: time)
}

// 현재 아이템 변경
func replaceCurrentItem(with item: AVPlayerItem?) {
  player.replaceCurrentItem(with: item)
}

// TimeObserver 설정
func addPeriodicTimeObserver(forInterval: CMTime, queue: DispatchQueue?, using: @escaping (CMTime) -> Void) {
  player.addPeriodicTimeObserver(forInterval: forInterval, queue: queue, using: using)
}
```



### Track

#### Extenstion+AVPlayerItem.swift

AVFoundation의 AVPlayerItem, AVMetadataItem 및 AVPlayer 을 `extension` 을 사용하여 확장

1. AVPlayerItem Extension

```swift
// 해당 함수를 추가 하여 AVPlyerItme -> Track struct 로 쉽게 변환하게 한다.
extension AVPlayerItem {
  func convertToTrack() -> Track? {
    let metadatList = asset.metadata

    var trackTitle: String?
    var trackArtist: String?
    var trackAlbumName: String?
    var trackArtwork: UIImage?

    for metadata in metadatList {
      if let title = metadata.title {
        trackTitle = title
      }

      if let artist = metadata.artist {
        trackArtist = artist
      }

      if let albumName = metadata.albumName {
        trackAlbumName = albumName
      }

      if let artwork = metadata.artwork {
        trackArtwork = artwork
      }
    }

    guard let title = trackTitle,
    let artist = trackArtist,
    let albumName = trackAlbumName,
    let artwork = trackArtwork else {
      return nil
    }
    return Track(title: title, artist: artist, albumName: albumName, artwork: artwork)
  }
}
```

2.  AVMetadataItem Extension

`func convertToTrack()` 에서 메타데이터를 쉽게 변환하기 위해 확장한다.

```swift
extension AVMetadataItem {
  var title: String? {
    guard let key = commonKey?.rawValue, key == "title" else { return nil }
    return stringValue
  }

  var artist: String? {
    guard let key = commonKey?.rawValue, key == "artist" else { return nil }
    return stringValue
  }

  var albumName: String? {
    guard let key = commonKey?.rawValue, key == "albumName" else { return nil }
    return stringValue
  }

  var artwork: UIImage? {
    guard let key = commonKey?.rawValue, key == "artwork", let data = dataValue, let image = UIImage(data: data) else { return nil }
    return image
  }
}
```

3. AVPlayer Extension

```swift
extension AVPlayer {
  // 현재 아이템이 없거나 rate가 0 인경우 정지 (false)
  var isPlaying: Bool {
    guard self.currentItem != nil else { return false }
    return self.rate != 0
  }
}
```

#### Track.swift

1. Track Struct

   트랙의 구조를 정의하기 위한 구조체

```swift
struct Track {
  let title: String
  let artist: String
  let albumName: String
  let artwork: UIImage

  init(title: String, artist: String, albumName: String, artwork: UIImage) {
    self.title = title
    self.artist = artist
    self.albumName = albumName
    self.artwork = artwork
  }
}
```

2. Album Struct

```swift
struct Album {
  let title: String
  let tracks: [Track]

  var thumbnail: UIImage? {
    return tracks.first?.artwork
  }

  var artist: String? {
    return tracks.first?.artist
  }

  init(title: String, tracks: [Track]) {
    self.title = title
    self.tracks = tracks
  }
}
```



#### TrackManager.swift

##### Properties

```swift
var tracks: [AVPlayerItem] = []
var albums: [Album] = []
var todayTrack: AVPlayerItem? 
```

##### Initializer

```swift
init() {
  let tracks = loadTracks()
  self.tracks = tracks
  self.albums = loadAlbums(tracks: tracks)
  self.todayTrack = self.tracks.randomElement()
}
```

#### Methods

```Swift
// 트랙 불러오기
func loadTracks() -> [AVPlayerItem] {
  // Resource 폴더에서 mp3확장자인 파일의 url들을 배열로 가져옴
  let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil) ?? []
  // 해당 url 들을 사용하여 AVPlayerItem으로 매핑 시킴
  let items = urls.map{ url in
                       return AVPlayerItem(url: url)
                      }
  return items
}
```

```swift
// 앨범 불러오기
func loadAlbums(tracks: [AVPlayerItem]) -> [Album] {
  // AVPlayerItem인 트랙들을 Track Struct로 매핑 시킨 배열
  let trackList: [Track] = tracks.compactMap{ item in
                                             return item.convertToTrack()
                                            }
  // trackList를 track.albumName을 이용하여 그룹화한 딕셔너리
  let albumDics = Dictionary(grouping: trackList){track in track.albumName}
	
  // 딕셔너리에서 키-밸류 튜플을 꺼내와 앨범들을 리스트에 넣어준다.
  var albums: [Album] = []
  for (key, value) in albumDics{
    let title = key
    let tracks = value
    let album = Album(title: title, tracks: tracks)
    albums.append(album)
  }
  return albums
}
```

```swift
// 오늘의 트랙 랜덤으로 선책
func loadOtherTodaysTrack() {
  self.todayTrack = self.tracks.randomElement()
}
```

```swift
// 인덱스에 맞는 트랙 로드하기
func track(at index: Int) -> Track? {
  let playerItem = tracks[index]
  return playerItem.convertToTrack()
}
```

