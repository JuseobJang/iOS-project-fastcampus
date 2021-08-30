# My Dog Cat Classifier App

**CoreML 을 이용한 머신러닝 모델 생성과 해당 모델을 이용한 강아지 및 고양이 분류 앱** 

<p align="center"> 
  <img width="250" alt="dog" src="https://user-images.githubusercontent.com/22047374/128481665-7b1c1982-6e28-4509-b3a7-e6b4c231e8b8.png">
	<img width="250" alt="cat" src="https://user-images.githubusercontent.com/22047374/128481678-578a9f8a-4908-4057-b383-18d158191de0.png">
</p> 

## CoreML Review

<p align="center"> 
  <img width="800" alt="dog" src="https://user-images.githubusercontent.com/22047374/131291449-a9704072-97c3-4420-b351-aad71dadd47f.png">
</p> 

1. **Image Classifier** 로 CoreML 프로젝트 생성

2. Training Data 추가 및 설정 후 Test Data를 설정해준다. (Validation Data 는 자동 설정)

   - Training 및 Test 데이터 이미지는 각 폴더에 라벨에 따라 나누어 들어가 있다.
   - 폴더의 이름을 해당 데이터의 라벨로 하고 트레이닝 및 테스트한다.

3. Training Data를 여러 조건을 변화 시켜가며 적용하여 트레이닝 시킨 후 테스트(테스트 데이터) 결과를 관찰한다.

   |                  트레이닝 데이터 종류                  |     Precision     |      Recall       |
   | :----------------------------------------------------: | :---------------: | :---------------: |
   |         데이터 량 100개, Maximum Iteration 25          | Dog 99%, Cat 98%  | Dog 98%, Cat 99%  |
   |         데이터 량 1000개, Maximum Iteration 25         | Dog 99%, Cat 98%  | Dog 98%, Cat 99%  |
   |          데이터량 100개, Maximum Iteration 40          | Dog 99%, Cat 98%  | Dog 98%, Cat 99%  |
   | 데이터량 100개, Augmentation 적용(noise, crop, rotate) | Dog 99%, Cat 100% | Dog 100%, Cat 99% |

>NOTE
>
>Precision : 고양이라고 한 것들 중에 진짜 고양이인 확률
>
>Recall : 전체 고양이들 중에 진짜 고양이를 맞힌 확률

<p align="center"> 
  <img width="800" alt="dog" src="https://user-images.githubusercontent.com/22047374/131293171-34490a72-5f15-4cde-bf83-62f03991d7e1.png">
  <p align= "center">
  	[Confidence 100% 를 보여주는 프리뷰 결과]  
	</p>
</p> 
4. 해당 프로젝트에서는 첫번 째 트레이닝 데이터를 사용한 머신러닝 모델을 아웃풋해서 앱 구현



## Code Review 

[Apple Developer : Classifying Images with Vision and Core ML](https://developer.apple.com/documentation/vision/classifying_images_with_vision_and_core_ml) 코드를 다운 및 수정 하여 구현

### ImageClassificationViewController.swift

기존 *MobileNet.mlmodel*  대신 CoreML을 이용하여 직접 만든 *DogCatClassifier.mlmodel* 로 대체한다.

```swift
lazy var classificationRequest: VNCoreMLRequest = {
  do {
		// MobileNet.mlmodel 대신 DogCatClassifier.mlmodel 사용
    let model = try VNCoreMLModel(for: DogCatClassifier().model)
    let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                                                                    self?.processClassifications(for: request, error: error)
                                                                   })
    request.imageCropAndScaleOption = .centerCrop
    return request
  } catch {
    fatalError("Failed to load Vision ML model: \(error)")
  }
}()
```



> Note
>
> 'DogCatClassifier' is only available in iOS 12.0 or newer 에러 발생
>
> Answer : 프로젝트에서 iOS Deployment Target 을 12.0 이상으로 변경 한다.

