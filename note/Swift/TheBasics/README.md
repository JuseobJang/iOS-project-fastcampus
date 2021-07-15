# The Basics

- Swift는 iOS, macOS, watchOs, tvOS 앱 개발을 위한 프로그래밍 언어이다. 

- Swift는 Int, Double, Float, String, Bool같은 기본적인 타입을 제공하고 Array, Set, Dictionary 같은 Collection types도 제공한다.

- Swift는 Variables(변수)와 Constants(상수) 를 사용한다.
  - 변수는 값을 변경할 수 있는 값이다.
  - 상수는 값을 변경할 수 없는 값이다. 상수는 코드를 좀 더 안전하고 명확하게 하기 위해 사용된다.

- Swift는 tuple이 사용가능 하기 때문에 값을 그룹화 하거나 여러 값을 동시에 리턴하는 것이 가능하다.

- Swift는 값의 부재를 다루기 위해 "Optional"을 제공하는데, Optional 만이 nil 값을 가질 수 있다. Optional 이 아니라면 필수적으로 값을 할당하여야 한다.

- Swift는 Type Safety Language 이기 때문에 개발 프로세스에 있어 빠르게 오류를 포착하고 수정 할 수 있도록 한다.



## Constants & Variables

### Declaring Constants & Variables

- Constatns(상수) 는 값이 변경 불가능하고 **let** 으로 선언한다.

- Variables(변수) 는 값을 변경 가능하고 **var** 로 선언한다.

```Swift
let maximumNumberOfLoginAttempts = 10
var currentLoginAttempt = 0
```

최대 로그인 가능 횟수는 값이 변경될 필요가 없는 고정 된 값이 때문에 상수로 선언하고 로그인 마다 현재 로그인 횟수는 증가해야 하므로 현재 로그인 횟수는 변수로 선언한다.

```Swift
let constant = 0 
costant = 1
// compile error 
var varible = 0
varible = 1
// change!!!
```

### Type Annotations

변수나 상수를 선언 할 때, Type Annotation을 할 수 있는데, 이는 값의 종류를 더욱 명확하게 저장하게 해준다.

```Swift
let exampleInt : Int = 0
let exampleStr : String = "Swift"
let exampleBool : Bool = true
```



## Comments

```Swift
// Single line comment

/*
	Multi
	Line
	Comment
*/
```



## Semicolons

세미 콜론은 일반적으로 사용하지 않으나 한 줄에 두가지 구문을 넣고 싶다면 세미콜론을 사용하면 된다.

```Swift
let myName: String = "seob_jj"; print(myName)
```



## Integers

- Integer type은 가능한 bit에 따라 Int, Int64 ~ Int8, UInt64 ~ UInt8 까지 존재한다.

- 각 타입의 최대 최소를 볼려면, max,min 속성을 사용하면 알 수 있다.

- Uint는 음수를 제외한 0부터 범위를 나타낸다.

- 일반적으로 일반 Int 는 64bit 운영체제 사용시 Int64, 32bit 운영체제 사용시 Int32와 같은 범위이다.

```Swift
let maxVal: UInt8 = UInt8.max // 255
let minVal: UInt8 = UInt8.min // 0
```



## Floating-Point Numbers

- Double Type 은 64bit floating number에 사용된다.
- Float Type 는 32bit floating number에 사용된다.



## Type Safety & Type Inference

- Swift는 type-safe language 이기 때문에 값의 타입을 명확히 하는 것을 추천한다. 이로써 어떤 타입을 필요로 하는 코드에 다른 타입을 사용하는 실수를 하지 않을 수 있다.
- Swift는 type-safe language 이기 때문에 컴파일시 해당 값의 타입이 올바른지 체크해준다. 그러면 개발 과정에서 더 빠르게 에러를 포착하고 수정할 수 있다.
- Swift는 Type Inference를 수행하기 때문에 만약 타입을 명시 하지 않더라도 가장 적절한 타입으로 설정해주기 때문에 컴파일시 에러가 나지 않는다. 
- Swift는 Type Inference를 지원하기 때문에 (지원하지 않는)다른 언어 보다 좀 더  간결하게 값을 선언할 수 있다.

- Type Inference는 Literal Value를 값에 할당 할 때 유용하게 사용할 수 있다.



## Numerical Literals

- 10진수 : no prefix
- 2진수 : 0b prefix
- 8진수 : 0o prefix
- 16진수 : 0x prefix

```Swift
let decimal = 17
let binary = 0b10001
let octal = 0o21
let hexadecimal = 0x11
```

Exponent

- 1.25e2 = 1.25 x 10^2 
- 1.25e-2 = 1.25 x 10^-2

```Swift
let decimalDouble = 12.1875
let exponentDouble = 1.21875e1
```

Padded with extra zero & underscore(_)

- 더 쉽게 읽거나 포맷을 맞추기 위해 사용된다.

```swift
let paddedNum = 000123.456
let underScoreNum = 1_000_000
```



## Numeric Type Conversion

### Integer Conversion

```Swift
let twoThousand: UInt32 = 2000
let twentyOne: UInt8 = 21
let twoThousandTwentyOne = 2000 + UInt32(twentyOne)
```



### Integer and Floating-point Conversion

```Swift
let three = 3
let pointOneFour = 0.14
let pi = Double(three) + pointOneFourOneFiveNine

let intPi = Int(pi) // 3
```



## Type Aliases

Type Alias 는 기존에 존재하는 타입의 이름을 대체하여 정의 할 수 있다. 보통 문맥적으로 좀 더 적합하게 표현하고 싶을 때 사용 한다. 기존 타입의 모든 메서드나 속성을 alias를 이용하여 그대로 사용 할 수 있다.

```Swift
typealias height = UInt8
var myHeight = height.max
```



## Booleans

Boolean 타입은 특히 **Control Flow**를 위한 if문 같은 조건 문에서 많이 사용된다. 

```Swift
var oneIsOdd = true
var oneIsEven = false
if oneIsOdd {
    print("1 is odd!")
} else {
    print("1 is not odd!")
}
// 1 is odd!
```



## Tuples

Tuple은 단일 값들을 조합한 그룹화된 다중 값이고 각각의 값은 다른 타입이어도 된다. 즉, 굳이 같은 타입일 필요는 없다. 

Example HTTP status code

```Swift 
let http404Error = (404, "Not Found") // tuple 선언

let (statusCode, statusMessage) = http404Error // tuple 내 두가지 값을 다 받을 시

let (statusCode, _ ) http404Error // tuple 내 한가지 값만 필요할 시
let (_ , statusMessage ) http404Error // tuple 내 한가지 값만 필요할 시

let code = http404Error.0 // 404, index로 tuple의 각 원소에 접근 할 수 있다.
let message = http404Error.1 // "Not Found"

let http200status = (code: 200, description: "OK") // tuple의 각 값에 명칭을 지정해 줄 수 있다.
```



## Optionals

값이 없는 상황에 대비해 Optional을 사용할 수 있다. Optional은 "?"로 표현한다. 또한 Optional의 경우 value가 존재할시 unwrap하여 접근하거나 value가 아에 존재 하지 않는 두가지 경우로 나눌 수 있다.

```Swift
let num = "123"
let convertNum = Int(num) 
```

이러한 경우 converNum 은 Int 타입이 아니라 Int? 타입이다. 왜냐하면 현재 num 의 경우 "123"이기 때문에 Int형으로 convert 가능하지만 다른 경우에는 convert가능할지 확실하지 않기 때문에 convert불가능한 경우 값의 부재를 표현 하는 nil값을 넣어야 한다. 그렇기 때문에 해당 convertNum의 타입은 Int?(Optional) 이 되는 것이다.



### nil

Optional 일 경우에만 값에 nil을 할당 할 수 있다. 또한 Optional일 경우 아무것도 할당 하지 않을 시 자동으로 nil이 할 당 된다.

```Swift
var optionalValue: Int? = 1000
optionalValue = nil

var optionalValue2: String? // nil이 할당된 상태
```



### If Statements & Forced Unwrapping

Optional은 해당 값에 접근하기 위해 Unwrapping을 해야 하는데 "!"를 사용하여 Forced Unwrapping을 할 수 있다. 하지만 nil 값인 경우 에러가 나기 때문에 If문을 사용하여 nil값이 아닐 때에만 Forced Unwrapping을 하는 것을 권장한다.

```Swift
let optionalValue: String? = "juseob"

if optionalValue != nil {
  print("My name is \(optionalValue).")
}
```



### Optional Binding

Forced Unwapping을 사용하지 Optional Binding을 활용하여 옵셔널에 값이 포함되어 있는 지 확인하고, 이 값을 임시 변수에 담아 사용할 수 있다. 

- if let 구문
- guard let 구문

```Swift
let optionalValue: Int? = 123

if let val = optionalValue { // optionalValue에 값이 존재할 시 아래 코드를 실행하고 임시 상수인 val을 활용 할 수 있다.
  // code
} else { // optionalValue에 값이 존재하지 않을 시 아래 코드를 실행한다.
  // code
}
```

guard let 구문에 경우 뒤에 else가 붙어 존재 하지 않을 시에 대해 code로 작성되며 마지막에 return을 하여 함수가 종료 되도록 한다. 



## Error Handling 

Erro Handling을 활용하여 프로그램 실행 중 발생하는 특정 에러에 반응 하여 처리 할 수 있다. 단지 함수의 성공 실패를 판별하는 것이 아니라, 에러 핸들링을 사용하면 실패의 근본적인 원인을 확인하고 필요시 해당 오류발생에 대한 대응코드를 실행 시킬수 있다.

에러조건을 마주 할 경우 함수는 에러를 throws한다. 그리고 에러를 catch하고 적절히 대응 할 수 있다.

```Swift 
func canThrowAnError() throws {
} // 이 함수는 error를 throw할 수도 있고 아닐 수도 있다. 즉 error가 발생할 확률이 있다는 것이다.

do{
  try canThrowAnError() // 해당 함수를 실행 시킨다.
  executeFunction() // 해당 함수가 정상적으로 작동시 현재 코드를 실행 시킨다.
  catch Error1{ // Error1 발생
    handlingError1() // Error1 발생시 Error1을 대응할 함수(코드)를 실행한다.
  }
  catch Error2{
    handlingError2()
  }
}
```



## Assertions & Preconditions

Assertions 과 Preoconditions은 런타임시 발생하는 검사이다. 코드를 실행하기 전 어떠한 필수조건이 만족하는지 확인하는데 사용한다. 만약 Assertion과 Precondition의 검사에서 false가 되면 프로그램이 유효하지 않은 것으로 판별하고 코드 실행을 종료한다.

Assertion은 개발 중 잘못된 가정과 실수를 찾는데 도움을 줄것이고, Precondition은 제품에서 발생 하는 issue를 찾는데 도움을 줄 것이다.

위에서 나타난 Error Handling과 달리 Assertions & Preconditions은 복구 가능하거나 예상되는 에러에 사용되지 않고 완전히 잘못된 프로그램 상태를 나타내기 위해 사용된다. 

따라서 Assertions & Preconditions은 잘못된 조건이 발생할 가능성을 낮게 하는 것이기 아니기 때문에 거기에 잘못된 조건이 발생할 확률이 낮게 나타날 수 있는 설계를 여전히 필요로 한다. 하지만 이를 사용하면 프로그램에 문제 발생시 더 예측가능하게 종료 가능하고 쉽게 디버그 할 수 있다. 또한 유효하지 않은 상태를 감지하는 즉시 실행을 종료하기 때문에 이로안한 손상을 어느정도 방지하는데 도움울 줄 수 있다.

Assertions & Preconditions의 차이점은 확인되는 시점에 있다. Assertions은 디버그 빌드에서만 확인 되지만 Preconditions는 디버그 및 프로덕션 빌드 모두에서 확인된다. 즉 어설션 내부조건은 프로덕션 빌드에서는 확인하지 않기 때문에 프로덕션 성능에 영향을 주지 않고 개발 프로세스에서 얼마든지 사용이 가능 하다. 

### Debugging with Assertions

assert(condition, message) 로 표현이되는데 해당 condition을 만족할 경우 자연스럽게 다음 코드가 실행이되고 만야 만족하지 않는다면 message를 출력하게 된다. 또한 message는 생략 가능하다. 

```Swift
let age = -3
assert(age>=1, "사람 나이는 1이상이어야 한다.")
// Assertion failed: 사람 나이는 1이상이어야 한다.
```

만약 코드에서 이미 조건이 체크가 되었다면 assertionFailure(message)를 사용할 수 있다. 이것은 Assertion이 fail했을 경우를 나타낸다.

```Swift
if age >= 7 {
  print("7세 이용가")
} else if age >= 1 {
  print("전체 이용가")
} else {
  assertionFailure("사람 나이는 1이상 이어야 한다.")
}
```



### Enforcing Preconditions

Preconditions 또한 Assertions와 표현하는 방식이 비슷하게 사용된다.

```Swift
let index = -1
precondition(index >= 0 , "index는 0이상이어야 한다.")
// Precondition failed: index는 0이상이어야 한다.
```

또한 assrtionFailure()와 같이 preconditionFailure()도 같은 방식으로 사용 될 수 있다. 







