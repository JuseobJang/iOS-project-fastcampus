# Full Screen Camera App

**AVFoundation의 Media Capture 를 이용하여 만든 풀 스크린 카메라 앱** 

<p align="center"> 
  <img width="250" alt="dog" src="https://user-images.githubusercontent.com/22047374/128517509-c5160da9-7c5a-4e3c-b861-ccc2be7bb0db.png">
	<img width="250" alt="cat" src="https://user-images.githubusercontent.com/22047374/128517530-14b65f7c-9112-4ef5-bfe4-ae3db239ef1e.png">
</p> 

## Permission

Info.plist 에서 카메라 권한을 허용 해준다.

<p align="center"> 
  <img width="800" src="https://user-images.githubusercontent.com/22047374/130407037-e35df694-3a33-48c8-ae08-d367a6ff3c4f.png">
</p> 



## Storyboard Review

### Main.storyboard

1. 카메라 화면이 보여질 preview(View)의 constraints를 superview의 leading, top, trailing, bottom에 맞추어 풀스크린으로 볼 수 있도록 한다. 
2. 캡쳐 버튼 주위를 둘러싸는 BlurBG View를 사용한다.
3. 각 컴포넌트에 오토 레이아웃 적용



## Code Review

### CameraViewController.swift

#### About Camera

카메라 촬영을 위한 AVFoundation 제공 객체

```swift
let captureSession = AVCaptureSession()
var videoDeviceInput: AVCaptureDeviceInput! // input
let photoOutput = AVCapturePhotoOutput() // output
```

디바이스의 카메라를 찾기 위한 섹션

```swift
let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(
  deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], // 아이폰 종류에 따른 camera 타입
  mediaType: .video,
  position: .unspecified) // 전면, 후면 카메라 또는 미지정
```

비디오(사진촬영) 과련 작업들은 해당 커스텀 큐에서 작업이 일어날 수 있도록 해줌

```swift
let sessionQueue = DispatchQueue(label: "session Queue")
```



1. func setpuSession : AVCaptureSession() 설정

```swift
// Setup session and preview
func setupSession() {
  // TODO: captureSession 구성하기
  // - presetSetting 하기
  // - beginConfiguration
  // - Add Video Input
  // - Add Photo Output
  // - commitConfiguration

  // 원하는 프리셋 설정
  captureSession.sessionPreset = .photo
  // 구성 시작할 것이라고 선언 (마치면 commit() 해야함)
  captureSession.beginConfiguration()
  
  // Session 에 input 과 output을 연결 하여야함
  
	// Add Video Input
  // videoDeviceDiscoverySession를 사용해 카메라 디바이스를 가져옴
  guard let camera = videoDeviceDiscoverySession.devices.first else{
    captureSession.commitConfiguration()
    return
  }
  // 디바이스를 가져와 디바이스 인풋을 만듬
  do{
    let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
    // 디바이스 인풋 추가 할 수 있는지 확인 없다면 커밋후 함수 종료
    if captureSession.canAddInput(videoDeviceInput) { 
      captureSession.addInput(videoDeviceInput)
      self.videoDeviceInput = videoDeviceInput
    } else {
      captureSession.commitConfiguration()
      return
    }
  } catch let error {
    captureSession.commitConfiguration()
    return
  }

  // Add output
  // output 설정한다.
  photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
  // 아웃풋을 추가할 수 있는지 확인 없다면 커밋후 함수 종료
  if captureSession.canAddOutput(photoOutput){
    captureSession.addOutput(photoOutput)
  } else {
    captureSession.commitConfiguration()
    return
  }

  captureSession.commitConfiguration()
}
```

2. func startSession : AVCaptureSession() 시작

```swift
func startSession() {
  sessionQueue.async {
    if !self.captureSession.isRunning{
      self.captureSession.startRunning()
    }
  }
}
```

3. func stopSessino : AVCaptureSession() 정지

```swift
func stopSession() {
  sessionQueue.async {
    if self.captureSession.isRunning{
      self.captureSession.stopRunning()
    }
  }
}
```



카메라 전환 버튼 클릭시 : 카메라 전/후면 변경 메서드

```swift
@IBAction func switchCamera(sender: Any) {
  // 카메라는 1개 이상이어야함
  guard videoDeviceDiscoverySession.devices.count > 1 else {
    return
  }
  // 반대 카메라 찾아서 재설정
  // - 반대 카메라 찾기
  // - 새로운 디바이스를 통해 세션을 업데이트
  // - 카메라 토글 버튼 업데이트

  sessionQueue.async {
    // 반대 카메라 찾기
    let currentVideoDevice = self.videoDeviceInput.device
    let currentPosition = currentVideoDevice.position
    let isFront  = currentPosition == .front
    // 목표 카메라 방향
    let prefferedPosition: AVCaptureDevice.Position = isFront ? .back : .front 

    let devices = self.videoDeviceDiscoverySession.devices
    var newVideoDevice: AVCaptureDevice?
    // 카메라들 중 목표 카메라 방향과 같은 방향인 카메라를 가져온다.
    newVideoDevice = devices.first(where: { device in
                                           return prefferedPosition == device.position
                                          })
    // 새로운 디바이스를 통해 세션을 업데이트
    if let newDevice = newVideoDevice {
      do{
        let videoDeviceInput = try AVCaptureDeviceInput(device: newDevice)
        self.captureSession.beginConfiguration()
        self.captureSession.removeInput(self.videoDeviceInput)

        if self.captureSession.canAddInput(videoDeviceInput){
          self.captureSession.addInput(videoDeviceInput)
          self.videoDeviceInput = videoDeviceInput
        } else {
          self.captureSession.addInput(self.videoDeviceInput)
        }
        self.captureSession.commitConfiguration()

        // 카메라 토글 버튼 업데이트
        DispatchQueue.main.async {
          self.updateSwitchCameraIcon(position: prefferedPosition)
        }
      } catch let error {
        print("error occured while creating device input: \(error.localizedDescription)")
      }
    }
  }

}
```

```swift
// Update ICON
func updateSwitchCameraIcon(position: AVCaptureDevice.Position) {
  switch position {
    case .front:
    let image = #imageLiteral(resourceName: "ic_camera_front")
    switchButton.setImage(image, for: .normal)
    case .back:
    let image = #imageLiteral(resourceName: "ic_camera_rear")
    switchButton.setImage(image, for: .normal)
    default :
    break
  }
}
```



촬영 버튼 클릭시 : 카메라 사진 촬영 메서드

```swift
@IBAction func capturePhoto(_ sender: UIButton) {
  // TODO: photoOutput의 capturePhoto 메소드
  // orientation 설정 : 현재 캡쳐 세션의 오리엔테이션을 가져와 똑같 저장될 사진에도 적용해줌
  let videoPreviewLayerOrientation = self.previewView.videoPreviewLayer.connection?.videoOrientation
  sessionQueue.async {
    // 오리엔테이션을 connection을 사용하여 설정함
    let connection = self.photoOutput.connection(with: .video)
    connection?.videoOrientation = videoPreviewLayerOrientation!

		// 캡쳐 세션에 연결된 photoOutput에 사진 찍으라고 요청
    let setting = AVCapturePhotoSettings()
    self.photoOutput.capturePhoto(with: setting, delegate: self) // delegate: self 사진 촬영 단계에 따른 처리를 따로 구현 할 수 있다.
```

```swift
// 사진 촬영이 완료 되었을 때 처리 구현
extension CameraViewController: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    // capturePhoto delegate method 구현
    guard error == nil else { return }
    guard let imageData = photo.fileDataRepresentation() else { return }
    guard let image = UIImage(data: imageData) else { return }
    self.savePhotoLibrary(image: image)
  }
}
```



사진 저장 메서드

```swift
// capture한 이미지 포토라이브러리에 저장
func savePhotoLibrary(image: UIImage) {
  // 일단 권한이 있는 지 확인한다.
  PHPhotoLibrary.requestAuthorization{ status in 
                                      // 만약 권한이 있다면 사진을 저장
                                      if status == .authorized{ PHPhotoLibrary.shared().performChanges(
                                        {PHAssetChangeRequest.creationRequestForAsset(from: image)},
                                        completionHandler: {(success, error) in print("저장 완료 ? \(success)")}
                                      )}
                                      // 권한이 없음
                                      else {
                                        print("---> 권한을 받지 못함")
                                      }
                                     }
}
```



#### override func & setting UI

```swift
// 상태바를 숨기기위한 오버라이딩 함수
override var prefersStatusBarHidden: Bool {
  return true
}
```

```Swift
override func viewDidLoad() {
  super.viewDidLoad()
  // 뷰가 메모리에 로딩된 후 캡셔세션을 설정 및 시작한다.
  previewView.session = captureSession
  sessionQueue.async {
    self.setupSession()
    self.startSession()
  }
  // UI 컴포넌트를 설정해준다.
  setupUI()
}
```

```Swift
func setupUI() {
  photoLibraryButton.layer.cornerRadius = 10
  photoLibraryButton.layer.masksToBounds = true
  photoLibraryButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
  photoLibraryButton.layer.borderWidth = 1

  captureButton.layer.cornerRadius = captureButton.bounds.height/2
  captureButton.layer.masksToBounds = true

  blurBGView.layer.cornerRadius = blurBGView.bounds.height/2
  blurBGView.layer.masksToBounds = true
}
```

### PreviewView.swift

[iOS Developer: AVCam](https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/avcam_building_a_camera_app) 의 예시코드를 사용













