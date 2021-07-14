# Collection Types

## Arrays(배열)

### 배열 선언

```swift
var arr1 : [Int] = [1,2,3,4]
var arr2 : Array<Int> = [1,2,3,4]
var arr3 = [1,2,3,4] // type 추론
var arr4 = [Int](repeating: 0, count: 4) // [0,0,0,0]
```

### 배열 조회

```swift
var arr : [Int] = [1,2,3,4]

arr[2] // 3

arr.prefix(3) // [1,2,3] 배열 앞에서 부터 3개 반환
arr.suffix(3) // [2,3,4] 배열 뒤에서 부터 3개 반환


// for문을 이용한 배열 조회 

for num in arr {
    print(num)
}

for index in 0..<arr.count{
    print(arr[index])
}

for (index, value) in arr.enumerated(){ // index, value 동시에 반환
    print("index : \(index), vlaue : \(value)")
}

// 값 포함 확인

arr.contains(1) // true
arr.contains(5) // false

```

### 배열 삽입

```swift
var arr : [Int] = [1,2,3,4]

// 단일값 추가
arr.append(5) // [1,2,3,4,5]

// 다중값 추가
arr.append(contentsOf: stride(from: 5, through: 7, by: 1)) // [1,2,3,4,5,6,7] 5~7 1간격으로 배열 생성하여 배열의 맨뒤에 추가
arr += [5,6,7] // [1,2,3,4,5,6,7] 배열의 맨뒤에 5,6,7 추가

// insert()를 이용한 값 추가
arr.insert(0, at: 0) // [0,1,2,3,4] // 0번째 index에 0 추가
arr.insert(contentsOf: [5,6,7], at: 4) // [1,2,3,4,5,6,7] // 4번째 index부터 5, 6, 7 차례로 추가
```

### 배열 삭제

```swift
var arr : [Int] = [0,1,2,3,4,5]

arr.remove(0) // [1,2,3,4,5] 0 번째 인덱스 값 삭제
arr.removeFirst() // [1,2,3,4,5] 첫번째 인덱스 값 삭제
arr.removeLast() // [0,1,2,3,4] 마지막 인덱스 값 삭제

var pre = arr.dropFirst(1) // pre = [1,2,3,4,5] 앞에서 부터 한개 제거한 배열 반환
var suf = arr.dropLast(1) // suf  = [0,1,2,3,4] 뒤에서 부터 한개 제거한 배열 반환

arr.popLast() // 5, arr = [0,1,2,3,4] 배열의 마지막 값을 리턴하고 실제 배열의 마지막 값을 삭제 한다.
```

### 배열 기타

```swift
var arr : [Int] = [4,3,2,1,0]

arr.sort() // [0,1,2,3,4] 배열 오름차순 정렬
arr.min() // 0, 배열 내 최솟값 반환
arr.max() // 4, 배열 내 최댓값 반환
arr.isEmpty // false, 배열이 비었는지 확인
arr.shuffle() // 배열 섞기
arr.randomElement() // 배열내에서 랜덤하게 반환
arr.reverse() // [0,1,2,3,4] 배열 순서 반전
```

## Sets(집합)

### Set 선언

```swift
var set1 : Set<Int> = []
var set2 : Set = [1,2,3]
var set3 = Set<Int>([1,2,3])
var set4 = Set([1,2,3])
```

### Set 조회

```swift
var set : Set = [1,2,3,4]

set.contains(4) // true

for num in set { // 일반 적인 for 문, 순서대로 넣어도 정렬이 되어있지 않음
    print(num) // 2,3,1,4
}

for num in set.sorted(){  // set 내에서 정렬 가능
    print(num) // 1,2,3,4
}

for (idx, num) in set.enumrated() { // set내 순서와 함께 출력
    print(idx, num) // (0,2) (1,3) (2,1) (4,4)
}
```

### Set 삽입 및 삭제

```swift
set.insert(5) // 중복 없이 데이터 삽입
set.remove(4) // 값이 Set에 존재 하면 삭제하고 그 값을 반환
set.remove(0) // 값이 Set에 존재 하지 않으면 nil 반환
```

### Set 집합 연산

```swift
var setA : Set = [1,2,3,4]
var setB : Set = [3,4,5,6]

setA.union(setB) // 합집합
setA.intersection(setB) // 교집합
setA.subtracting(setB) // 차집합
setA.symmetricDifference(setB) // 합집합 - 교집합

// of 매개 변수에 Set이 아니라 배열이 들어와도 됨
```

### Set 부분 집합 판별

```swift
var superSet : Set = [1,2,3,4]
var subSet : Set = [1,2]
var otherSet : Set = [5,6]

subSet.isSubset(of: superSet) // subSet이 superSet의 부분 집합인지 확인
superSet.isSuperset(of: subSet) // subSet이 superSet의 부분 집합인지 확인
otherSet.isDisjoint(with: superSet) // otherSet 과 superSet이 겹치는게 있는지 확인

// of 매개 변수에 Set이 아니라 배열이 들어와도 됨
```

## Dictionary

### Dictionary 선언

```swift
var dict1:[Int : String] = [:]
var dict2:Dictionary<Int,String> = [:]
var dict3 = [1: "apple"]
var dict4 : Dictionary = [1: "apple"]
// type을 명시해주어야지만 빈 dict를 생성할 수 있다.
```

### Dictionary 조회

```swift
var dict: [Int : String] = [1 : "apple" , 2: "banana" , 3: "orange"]
dict[1] // apple

for (key, value) in dict { /
    print(key, value) 
}

for key in dict.keys{
    print(key)
}

for value in dict.values{
    print(value)
}
```

### Dictionary 삽입 갱신 삭제

```swift
var dict: [Int : String] = [1 : "apple" , 2: "banana" , 3: "orange"]

dict[4] = "watermelon" // key가 존재 하지 않으면 삽입
dict[1] = "pineapple" // key가 존재 하면 갱신
dict.updateValue("kiwi", forKey: 1) // 메소드를 이용한 갱신
dict.removeValue(forKey: 1) // 삭제후 value 반환
```
