# MVC pattern

<p align = "center">
  <img src="https://user-images.githubusercontent.com/22047374/125561993-ad2cd0a7-9546-4217-936f-e13517d77829.png" height="200px" width="400px">
</p>
![MVC]()

Model: 데이터와 비즈니스 로직을 관리

View: 레이아웃과 화면을 처리

Controller: 명령을 모델과 뷰 부분으로 라우팅

위 그림은 전통적인 MVC 패턴의 구조이다. 전통적인 MVC 패턴은 각각의 개체는 나머지 두 개체를 반드시 알아야하고 그로 인해 결합도가 증가 하면서 독립성이 감소하게 된다. 독립성이 감소하게된 각 개체는 재사용성이나 유지보수성이 떨어진다. 따라서 전통적인 MVC 패턴의 이러한 한계점을 보완 하기 위해 애플의 cocoa MVC가 등장하게 된다.

## Apple's MVC pattern

### Cocoa MVC Pattern

<p align = "center">
  <img src="https://user-images.githubusercontent.com/22047374/125562399-7a62d77d-3704-4d5b-8006-e5cf12e749df.png" height="200px" width="400px">
</p>

전통적인 MVC패턴을 보완하기 위해 등장한 해당 패턴은 모델과 뷰 사이의 관계를 끊고 Controller가 중간에서 중재자 역할을 함으로서 View와 Model의 독립성을 증가 시킨다.

<p align = "center">
  <img src="https://user-images.githubusercontent.com/22047374/125563457-fbe6d44f-b25d-4a82-a24f-8bda26b20898.png" height="200px" width="400px">
</p>


하지만 실제 Controller 역할을 맡고 있는 UIViewController는 View를 포함하고 View의 Life Cycle 까지 관리하기 때문에 View 와 Controller를 분리 할 수 없을 뿐만 아니라 재사용이나 테스트면에서도 어렵다.
또한 결과적으로 UIViewController의 역할이 과도하게 증가함으로서 Massive View Controller라는 말도 나왔다.

이러한 MVC pattern 의 문제로 현재는 MVVM 이나 VIPER와 같은 다른 디자인 모델을 많이 사용하는 추세이다.

---

- [MVVM Pattern](../MVVM)
- [VIPER Pattern](../VIPER)

Reference

<https://jiyeonlab.tistory.com/38>
