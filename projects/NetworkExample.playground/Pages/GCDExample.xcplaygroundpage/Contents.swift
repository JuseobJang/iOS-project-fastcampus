import UIKit

// Queue - Main, Global, Custom

// main
DispatchQueue.main.async {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
}

// global
DispatchQueue.global(qos: .userInteractive).async {
    // priority 1
}

DispatchQueue.global(qos: .userInitiated).async {
    // priority 2
}

DispatchQueue.global(qos: .default).async {
    // priority 3
}

DispatchQueue.global(qos: .utility).async {
    // priority 4
}

DispatchQueue.global(qos: .background).async {
    // priority 5
}

// custom
let concurrentQueue = DispatchQueue(label: "concurrent" , qos: .background, attributes: .concurrent)

// 복합적인 상황
func downloadImageFromServer() -> UIImage {
    return UIImage()
}

func updateUI(image: UIImage){
    
}

DispatchQueue.global(qos: .background).async {
    let image = downloadImageFromServer()
    DispatchQueue.main.async {
        updateUI(image: image) // UI 관련 작업은 main 스레드 에서 실행 
    }
}


// Sync, Async

// Sync
DispatchQueue.global(qos: .background).sync { // 아무리 덜 중요해도 먼저 처리 후 다음 작업 실행
    for i in 0...5{
        print("hi \(i)")
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...5{
        print("bye \(i)")
    }
}
