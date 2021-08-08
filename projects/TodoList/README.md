# Todo List App

### Todo List App

**테이블 및 콜렉션 뷰와 체크박스 등을 이용하여 계획을 작성하는 Todo list 앱**

<p align="center"> 
  <img width="250" alt="Todo1" src="https://user-images.githubusercontent.com/22047374/128479447-4e2eac6c-a974-431e-892d-9a864661e0fa.png">
	<img width="250" alt="Todo2" src="https://user-images.githubusercontent.com/22047374/128479285-5820999b-69c5-450c-8b6c-2a43aa67b9df.png">
</p> 

## Storyboard Review

### Main.storyboard

#### Tab Bar Controller

Tab Bar Controller 에 Tasks Scene과 Settings Scene을 Embedded 시켜서 아래 탭바를 통해 원하는 뷰컨트롤러로 세그를 통해 화면 전환을 할 수 있도록 해준다. 

#### Tasks Scene

**Collection View**

- Todo List Header View 
  - Collection Reuseable View를 이용하여 Header를 구성하고 custom class를 사용할 것이기 때문에 Identifier의 Custom Class 를 `TodoListHeaderView` 로 설정하여 준다. 
  - Header의 내용을 표기하기 위한 Label로 구성되어 있다.

- Todo List Cell 
  - 이 또한 기본 Cell을 사용하는 것이아닌 custom cell을 사용할 것이므로  Identifier의 Custom Class 를 `TodoListCell` 로 설정하여 준다.
  - 각 cell은 완료를 표시하기 위한 Check Box, Todo의 내용을 나타내기 위한 Label, 삭제를 위한 Button 그리고 완료시 표시될 삭선(View)으로 구성되어 있다.

**Input Text Field**

 해당 필드에는 Todo 를 작성하기 위한 Text Field와 오늘 할일인지 체크하기 위한 Today Buttom 그리고 Todo를 추가(확정) 하기 위한 '+' Button으로 구성되어 있다.



> **Note**
>
> 1. 체크 박스나 일반 버튼의 상태에 따른 뷰를 확인 하고 싶다면 Control 의 state를 설정해주면 된다.
> 2. Custom으로 설정한 Cell 이나 Header의 경우 ViewController 코드에 사용하기 위해 Identifier를 설정해야 한다.
> 3. Cell의 사이즈는 코드에서 설정할 것이기 때문에 size는 custom으로 설정한다.



#### Setting Scene

Setting Scene의 Table View는 항상 일정한 Table View Cell을 보여줘야 하기 때문에 content 값을 static cells로 설정하고 Table View Section의 Rows를 3으로 설정한다. 

Table View Cell의 각 내용을 Label에 작성하여 추가한다. 



## Code Review

### TodoListViewController.swift

View Model을 따로 생성해서 Storage에 있는 Todo 들에 관한 내용을 처리 할 수 있도록 해주고 View Controller는 뷰에 관련된 작업들만 할 수 있도록 하여 준다.

```swift
let todoListViewModel = TodoViewModel()
```



Collection View를 사용하기 위해 **UICollectionViewDataSource** 와 **UICollectionViewDelegateFlowLayout** 프로토콜을 extension을 사용하여  채택한다.

**UICollectionViewDataSource** 에서는 해당 내용들에 대해 구현하여야 한다.

1. 섹션의 갯수 

```swift
func numberOfSections(in collectionView: UICollectionView) -> Int {
  return todoListViewModel.numOfSection
}
```

2. 섹션별 아이템 갯수

```swift
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  if section == 0 {
    return todoListViewModel.todayTodos.count // 위에 섹션에는 Today Todo의 갯수
  } else {
    return todoListViewModel.upcompingTodos.count // 아래 섹션에는 Upcoming Todo의 갯수
  }
}
```

3. Custom Cell에 어떻게 표현할 것인지

```swift
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  // withReuseIdentifier 를 활용하여 스토리 보드의 cell을 가져와서 TodoListCell로 타입 캐스팅한다.
  guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoListCell", for: indexPath) as? TodoListCell else {
    return UICollectionViewCell()
  }

  // Section 에 따라 Today 또는 Upcoming todo 배열에서 todo(item)을 가져온다.
  var todo: Todo
  if indexPath.section == 0 {
    todo = todoListViewModel.todayTodos[indexPath.item]
  } else {
    todo = todoListViewModel.upcompingTodos[indexPath.item]
  }
  // 해당 todo를 이용해 cell의 UI를 업데이트 한다.
  cell.updateUI(todo: todo)

  // done buttom 탭 Handelr 구현
  cell.doneButtonTapHandler = { isDone in 
                               todo.isDone = isDone // 상태 변환
                               self.todoListViewModel.updateTodo(todo) // viewModel을 이용하여 todo 업데이트
                               self.collectionView.reloadData() // 콜렉션뷰를 업데이트 반영된 뷰로 리로딩
                              }

  // delete buttom 탭 Handelr 구현
  cell.deleteButtonTapHandler = {
    self.todoListViewModel.deleteTodo(todo) // viewModel 을 이용하여 todo 삭제
    self.collectionView.reloadData() // 삭제가 반영된 콜렉션 뷰로 리로딩 
  }
  return cell
}
```

4. Header를 어떻게 표현할 것이지

```swift
func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
  switch kind {
    // UICollectionReusableView의 Header 인 경우 (Footer를 사용한다면 Footer에 대해서 구현할 수 있다.) 
    case UICollectionView.elementKindSectionHeader:
    // 스토리보드에서 지정한 ReuseIdentifier를 사용하여 header를 가져와 TodoListHeaderView로 타입 캐스팅한다.
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodoListHeaderView", for: indexPath) as? TodoListHeaderView else {
      return UICollectionReusableView()
    }

    // indexPath.section: Int 를 사용하여 viewModel로 부터 section에 필요한 내용을 가져온다.
    guard let section = TodoViewModel.Section(rawValue: indexPath.section) else {
      return UICollectionReusableView()
    }

    // 위에서 가져온 section을 사용하여 header의 내용을 설정해준다.
    header.sectionTitleLabel.text = section.title
    return header
    default:
    return UICollectionReusableView()
  }
}
```



**UICollectionViewDelegateFlowLayout** 에서는 해당 내용이 구현되어야 한다.

Collection View Cell의 사이즈 구하기

```swift
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  // CollectionView를 테이블 뷰로 사용할 것이기 때문에 CollectionView의 최대 width를 사용하고 height는 50으로 고정한다.
  let width: CGFloat = collectionView.bounds.width
  let height: CGFloat = 50
  return CGSize(width: width, height: height)
}
```

Text Field 선택시 키보드가 올라오거나 다시 화면 클릭 시 키보드가 내려갈때 Text Field도 함께 움직여야하기 때문에 키보드 show, hide에 관한 이벤트 옵저버를 추가하여 Text Field가 위아래로 이동할 수 있도록 해준다.

해당 함수는 Observer가 이벤트를 감지했을 때 동작 할 함수 이다.

```swift
@objc private func adjustInputView(noti: Notification) {
  guard let userInfo = noti.userInfo else { return }
  // 키보드 크기에 완한 정보를 불러온다.
  guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return } 

  // keyboardWillShowNotification 이 발생한 경우
  if noti.name == UIResponder.keyboardWillShowNotification {
    let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
    inputViewBottom.constant = adjustmentHeight // InputTextField의 Bottom constant를 계산된 값으로 변경해준다.
    // keyboardWillHideNotification 이 발생한 경우
  } else {
    inputViewBottom.constant = 0 // InputTextField의 Bottom constant를 0 변경해준다.
  }
}
```

아래 코드를 viewDidLoad() 함수에 추가하여 준다.

```swift
// NotificationCenter.default.addObserver()를 사용하여 show 와 hide에 이벤트에 대해 adjustInputView()를 실행 시킬 수 있도록 Observer를 추가하여 준다.
NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)

NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)        

```



Collection View Cell을 커스텀해서 사용하기 위해 `UICollectionViewCell`를 상속받는 `TodoListCell` 클래스를 생성한다.

```swift
class TodoListCell: UICollectionViewCell {}
```

해당 Cell은 다음과 같은 메서드를 갖는다.

```swift
// Todo 인스턴스 받아 해당 속성을 통해 Cell의 UI를 업데이트 한다.
func updateUI(todo: Todo) {
  checkButton.isSelected = todo.isDone
  descriptionLabel.text = todo.detail
  descriptionLabel.alpha = todo.isDone ? 0.2 : 1
  deleteButton.isHidden = todo.isDone == false
  showStrikeThrough(todo.isDone)
}

// Check Box가 탭 되었을때 Check Box의 상태에 따라 UI를 업데이트 한다.
@IBAction func checkButtonTapped(_ sender: Any) {
  checkButton.isSelected = !checkButton.isSelected
  let isDone = checkButton.isSelected
  showStrikeThrough(isDone)
  descriptionLabel.alpha = isDone ? 0.2 : 1
  deleteButton.isHidden = !isDone

  // 핸들러를 통해 Todo 객체에 대한 변화를 업데이트 한다. 물론 핸들러는 해당 Cell을 사용하는 부분에서 정의한다.
  doneButtonTapHandler?(isDone) 
}

@IBAction func deleteButtonTapped(_ sender: Any) {
  // 핸들러를 통해 Todo 객체에 대한 변화를 업데이트 한다. 물론 핸들러는 해당 Cell을 사용하는 부분에서 정의한다.
  deleteButtonTapHandler?()
}
```

```swift
// 위의 이 두가지 핸들러는 클래스의 속성 부분에 명시되어 있다.
var doneButtonTapHandler: ((Bool) -> Void)?
var deleteButtonTapHandler: (() -> Void)?
```

### Todo.swift

 Todo Strucure,  TodoManager Class  그리고 ViewModel Class를 정의한다.

1. Todo Structure

Todo 는 할 일에 대한 여러 속성들을 담고 있는 구조체이다.

```swift
// Codable : Json 형식으로 Encodig 및 객체로 Decoding 하기 위해 사용하는 프로토콜
// Equatable : == 에 대하여 정의 할 수 있는 프로토콜
struct Todo: Codable, Equatable {
  let id: Int
  var isDone: Bool
  var detail: String
  var isToday: Bool

  // 매개변수로 전달된 값들로 속성을 업데이트 한다.
  mutating func update(isDone: Bool, detail: String, isToday: Bool) {
    self.isDone = isDone
    self.detail = detail
    self.isToday = isToday
  }

  // Equatable 프로토콜로 인해 구현, id 가 같은 인스턴스는 같은 인스턴스로 한다.
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}
```

2. TodoManager Class

TodoManger는 여러개의 Todo를 배열에 담아 관리한다. 여기서 Todo를 생성하고 배열에 추가, 삭제, 기존 Todo 업데이트, 파일로 저장 그리고 파일에서 불러오기 기능을 수행한다.

TodoManager는 앱내에서 하나의 객체만 필요할 것으로 보이기 때문에 싱글톤 패턴을 적용한다.

```swift
class TodoManager {
  // Sigleton 객체 사용
  static let shared = TodoManager()
  static var lastId: Int = 0

  var todos: [Todo] = [] 

  // Todo 생성
  func createTodo(detail: String, isToday: Bool) -> Todo {
    let nextId = TodoManager.lastId + 1
    TodoManager.lastId = nextId
    return Todo(id: nextId, isDone: false, detail: detail, isToday: isToday)
  }
  // Todo를 배열에 추가
  func addTodo(_ todo: Todo) {
    todos.append(todo)
    saveTodo()
  }
  
  // Todo를 배열에서 삭제
  func deleteTodo(_ todo: Todo) {
    if let index = todos.firstIndex(of: todo) {
      todos.remove(at: index)
      saveTodo()
    }
  }

  // Equable로 id가 같으면 같은 Todo로 취급하기 때문에 같은 id인 Todo를 찾은 후 전달 받은 Todo의 나머지 속성 들로 업데이트 한다.
  func updateTodo(_ todo: Todo) {
    guard let index = todos.firstIndex(of: todo) else { return }
    todos[index].update(isDone: todo.isDone, detail: todo.detail, isToday: todo.isToday)
    saveTodo()
  }

  // todos 배열을 Storage를 사용하여 todos.json 파일로 저장한다. 파일!
  func saveTodo() {
    Storage.store(todos, to: .documents, as: "todos.json")
  }

  // todos.json 파일로 붙어 todos를 불러온다.
  func retrieveTodo() {
    todos = Storage.retrive("todos.json", from: .documents, as: [Todo].self) ?? []
    let lastId = todos.last?.id ?? 0 // todos.last가 존재하면 해당 id로 아니라면 0 을 lastId 로 한다.
    TodoManager.lastId = lastId
  }
}
```



3. ViewModel Class

해당 클래스에서는 TodoManager의 싱글톤 객체를 속성으로 가지고 있다. 또한 뷰에서 해당 ViewModel을 통해서 TodoManager에서 할 수 있는 여러가지 기능들을 수행 할 수 있도록 하여준다.



### Storage.swift

TodoManager에서 todos에 추가, 삭제, 변경 과 같은 작업이 발생하면 `Storage.store(todos, to: .documents, as: "todos.json")` 를 실행하여 todos.json 파일로 todos의 Todo 객체들을 json 형식으로 인코딩 하여 저장해준다.

```swift
// Encodable protocol을 준수하는 객체에 대해서 store() 할 수 있다. 
// Codable: Encodable, Decodable이기 때문에 Codable 프로토콜을 따르는 Todo는 가능 하다.
static func store<T: Encodable>(_ obj: T, to directory: Directory, as fileName: String) {
  let url = directory.url.appendingPathComponent(fileName, isDirectory: false) // 디렉토리 url을 가져온다.
  print("---> save to here: \(url)")
  let encoder = JSONEncoder() // 인코더 인스턴스
  encoder.outputFormatting = .prettyPrinted // 출력 형식 설정

  // 인코딩 작업 
  do {
    let data = try encoder.encode(obj)
    if FileManager.default.fileExists(atPath: url.path) { // 기존 파일이 존재하면 삭제
      try FileManager.default.removeItem(at: url)
    } 
    FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil) // 인코딩 된 데이터를 url에 저장
  } catch let error {
    print("---> Failed to store msg: \(error.localizedDescription)")
  }
}
```



또한  `Storage.retrive("todos.json", from: .documents, as: [Todo].self)` 를 사용하여 저장된 todos.json 파일을 불러와 json 파일을 디코딩하여 todos 배열을 반환해 준다. 

```swift
// Decodable protocol을 준수하는 객체에 대해서 retrive() 할 수 있다. 
// Codable: Encodable, Decodable이기 때문에 Codable 프로토콜을 따르는 Todo는 가능 하다.
static func retrive<T: Decodable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
  let url = directory.url.appendingPathComponent(fileName, isDirectory: false)
  guard FileManager.default.fileExists(atPath: url.path) else { return nil } // 파일 존재 체크
  guard let data = FileManager.default.contents(atPath: url.path) else { return nil } // 파일 내 내용이 존재하는 지 체크

  let decoder = JSONDecoder() // 디코더 인스턴스

  // 해당 json파일을 디코딩 하여 Todo를 반환한다.
  do {
    let model = try decoder.decode(type, from: data)
    return model
  } catch let error {
    print("---> Failed to decode msg: \(error.localizedDescription)")
    return nil
  }
}
```























