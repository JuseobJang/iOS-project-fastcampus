# Strings & Characters

String은 Characters의 series이다. Swift String은 "String"으로 타입을 명시한다. String의 내용은 다양한 방식으로 접근가능하다.

Swift의 String과 Character은 Unicode-compliant방식으로 상당히 빠르다. String 생성 및 조합 문법은 가볍고 읽기 쉬우며 C언어와 비슷한 문법을 보인다. String을 합치는 것도 단순히 + 연산을 사용하여 합칠 수 있다. 

이처럼 Swift의 String은 빠르고 간단하면서 현대적으로 구현되었다. 

## Initializing an Empty String

```Swift
var emptyString1 = ""
var emptyString2 = String()

// 이 두가지 빈 String은 결과적으로 같다
```



## String Mutuability

```Swift
var lastName = "Jang"
lastName += "Juseob" // Jang Juseob

let lastName = "Kang"
last += "Eunji" // lastName이 constant로 선언 되었기 때문에 변경 불가하여 compile error 발생
```



## Strings Are Value Types

Swift의 String은 value type이기 때문에 어떠한 String 변수를 함수나 메서드에 전달하거나 변수에 할당 할 시 복사 됩니다. 

Swift의 copy-by-default String 행동은 함수나 메서드에 값을 전달할 시 이 값의 출처에 상관없이 그 안에서 정확한 String값을 소유하고 있는 것을 명확히 한다.

Swift 컴파일러는 실제 복사가 절대적으로 필요한 경우에만 발생하도록 String 사용을 최적화 한다. 이는 String을 value type으로  사용할 때 항상 뛰어난 성능을 얻을 수 있다는 것을 의미한다.



## Working with Characters

```Swift
var strValue = "Sleep"
for char in strValue {
  print(char)
}
// S
// l
// e
// e
// p

let nameArray:[Character] = ["j","u","s","e","o","b"]
let nameString: String = String(nameArray)
```



## Concatenating Strings and Characters

```Swift
let str = "My name is "
let name = "juseob"
var intro = str + name // My name is juseob
str += juseob // str = "My name is juseob"

// String 뒤에 Character을 추가 할 때는 append() 메서드를 사용하여 추가
let mark: Character = "!"
intro.append(mark) // My name is juseob!
```



## String Interpolation

```Swift
let twenty = 20
let message = "\(twenty) times 1.5 is \(Double(twenty) * 1.5)"
// "20 times 1.5 is 30.0"
```



## Counting Character

```Swift
let sentence = "To retrieve a count of the Character values in a string, use the count property of the string"

print(sentence.count) // 93
```



## Accessing and Modifying a String

### String Indices

```Swift
let greeting = "Hello!"
greeting[greeting.startIndex] // H
greeting[greeting.endIndex] // Error
greeting[greeting.index(before: greeting.endIndex)] // !
greeting[greeting.index(after: greeting.startIndex)] // e

let index = greeting.index(greeting.startIndex, offsetBy: 3) // offesetBy = 0 은 기준 인덱스
greeting[index] // l

// print시 terminator를 전달해 개행이 아닌 마지막에 다른 문자열을 줄 수 있다.
for index in greeting.indices {
    print("\(greeting[index])", terminator: " ")
} // H e l l o ! 
```



### Inserting and Removing

```Swift
var welcome = "hello"
// 한개의 character을 원하는 인덱스에 추가 할때는 insert(_: at:)
welcome.insert("!", at: welcome.endIndex)  // hello!
// 문자열을 추가할 때는 insert(contentsOf: at:)
welcome.insert(contentsOf: " there", at: welcome.index(before: welcome.endIndex)) // hello there

```



## Substrings

```Swift
let greeting = "Hello, world!"
let index = greeting.firstIndex(of: ",") ?? greeting.endIndex // ","을 찾을수 없을 것을 대비해 default값으로 마지막 인덱스 값을 줌
let beginning = greeting[..<index] // beginning 은 String.subsequence 타입
// beginning = "Hello"

let newString = String(beginning) // String.subsequence 이므로 String으로 변환해준다.
```



### Split & Components

```Swift
let greeting = "Hello, world! good"

let componentResult = greeting.components(separatedBy: " ")
// ["Hello,","world!","good"] : [String]

let splitResult1 = greeting.split(separator: " ")
// ["Hello,","world!","good"] : [String.subsequence]
let splitResult2 = greeting.split(separator: " ", maxSplits: 1)
// // ["Hello,","world! good"] : [String.subsequence] maxSplits 만큼 분리함
```



## Comparing Strings

### String and Character Equality

```swift
// String 비교
let str1 = "Hello"
let str2 = "Hello"
if str1 == str2 { // true
  print("str1 is same str2") 
}
// character 비교
let char1: Character = "J"
let char2: Character = "J"
if char1 == char2 { // true
  print("char1 is same char2")
}
```



### Prefix and Suffix Equality

```swift
let romeoAndJuliet = [
    "Act 1 Scene 1: Verona, A public place",
    "Act 1 Scene 2: Capulet's mansion",
    "Act 1 Scene 3: A room in Capulet's mansion",
    "Act 1 Scene 4: A street outside Capulet's mansion",
    "Act 1 Scene 5: The Great Hall in Capulet's mansion",
    "Act 2 Scene 1: Outside Capulet's mansion",
    "Act 2 Scene 2: Capulet's orchard",
    "Act 2 Scene 3: Outside Friar Lawrence's cell",
    "Act 2 Scene 4: A street in Verona",
    "Act 2 Scene 5: Capulet's mansion",
    "Act 2 Scene 6: Friar Lawrence's cell"
]

var act1Cnt = 0
for scene in romeoAndJuliet {
  if(scene.hasPrefix("Act 1 ")){ // hasPrefix()를 이용해 해당 문자열로 시작하는지 확인 가능
    act1Cnt += 1
  }
}
print(act1Cnt) // 5

var endMansionCnt = 0

for scene in romeoAndJuliet {
  if(scene.hasSuffix("mansion")){ // hasSuffix()를 이용해 해당 문자열로 끝나는지 확인 가능
    endMansionCnt += 1
  }
}
print(endMansionCnt) // 6
```























