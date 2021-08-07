# My Album App

**테이블 뷰와 체크박스 등을 이용하여 계획을 작성하는 Todo list 앱** 

<p align="center"> 
	<img width="250" alt="MyAlbum1" src="https://user-images.githubusercontent.com/22047374/128318123-9a6e18dd-19ca-4c3a-ac29-d7443dea7a82.png">
</p> 

## Storyboard

### Main.storyboard

- `Label`, `ImageView`, `Button` 속성(글자 크기, 색상, 스타일 등) 변경한다.
- 오토레이아웃 적용을 위한 Constraints 및 width/ height 적용한다.
- Refresh 버튼 Outlet의 Touch Up Inside 이벤트 ViewController와 연결한다.
- priceLabel ViewController와 연결한다.



## View Controller

### ViewController.swift

- `overrid func viewDidLoad()` :  뷰의 컨트롤러가 메모리에 로드된 후 호출한다.

  - `priceLabel.text` 값을 `currentValue` 로 설정 (초기값 = 0) 한다.

  - 바로 `refresh()`  실행 되기 때문에 실제로 0 이 표시 되진 않는다.

    

- `refresh()` :  `priceLabel.text` 를 0 ~ 10000사이 값으로 랜덤하게 설정해주는 함수이다.

  - `arc4random_uniform(10000)+1`  을 활용하여 랜덤한 값을 가져온다.

    

- `@IBAction func hello(_ sender: Any)` : 스토리 보드의 Refresh 버튼과 Touch Up Inside 이벤트로 연결 한다.

  ```swift
  let message = "가격은 ￦ \(currentValue) 입니다." // ㅁlert message
  
  let alert = UIAlertController(title: "Hello", // alert 생성 
                                message: message,
                                preferredStyle: .alert)
  let action = UIAlertAction(title: "OK", // alert 확인시 액션 생성
                             style: .default,
                             handler:{
                               action in self.refresh() // 확인 클릭시 refresh() 실행
                             })
  
  alert.addAction(action) // 생성한 alert에 방금 생성한 action 추가
  present(alert, animated: true, completion: nil) // present를 사용하여 해당 alert를 보여줌
  ```

  

## ETC

프로젝트의 Assets.xcassets 폴더에서 앱아이콘 또는 이미지 등을 관리 할 수 있다.
