# MVVM pattern

<p align = "center">
  <img src="https://user-images.githubusercontent.com/22047374/125567835-7f8e226b-7525-4fb4-9997-be1bb0a43a14.png" height="200px" width="400px">
</p>

Model: 데이터와 비즈니스 로직을 관리

View: 레이아웃과 화면을 처리

View Model: View를 나타내기 위한 데이터 처리

## 특징 및 장점

- MVVM의 View, Model 은 MVC의 View, Model과 같은 역할을 수행한다.

- MVVM의 View Model은 MVC의 Controller와 같이 중재자 역할을 수행한다. 이때 바인더라는 것을 사용하는데 View 와 View Model 사이에서 상태(모델)변화에 대한 통신을 자동화 하는 역할을 수행한다.

- MVC의 View 와 View Controller는 View 개체에 속하게 된다.

- View Model은 Model들과 일대 다 관계를 형성하는 것이 바람직하다.

- 뷰 모델이 모델과 뷰 사이의 어댑터로서 변경이 생겼을 때 변경을 최소화할 수 있다.

- 모델과 뷰 모델이 뷰로부터 독립적이다.

---

- [MVC Pattern](../MVC)

Reference

<https://hyunsikwon.github.io/ios/iOS-ArchitecturePatterns-01/>

<https://velog.io/@k7120792/Model-View-ViewModel-Pattern>

<https://ko.wikipedia.org/wiki/%EB%AA%A8%EB%8D%B8-%EB%B7%B0-%EB%B7%B0%EB%AA%A8%EB%8D%B8>
