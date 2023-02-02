# 📒 Mongsil

### 프로젝트 기간
<2022-12-29 ~ 2023-01-30>

## 📖 목차
1. [소개](#-소개)
2. [실행 화면](#-실행-화면)
3. [고민한 점](#-고민한-점)
4. [트러블 슈팅](#-트러블-슈팅)
5. [참고 링크](#-참고-링크)

## 🌱 소개
### 💻 개발환경 및 라이브러리

[![swift](https://img.shields.io/badge/swift-5.0-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-14.2-blue)]()
[![iOS](https://img.shields.io/badge/iOS-13.4-green)]()
<img src="https://img.shields.io/badge/Combine-orange?style=flat&logo=Swift&logoColor=ffffff"/>
<img src="https://img.shields.io/badge/SPM-orange?style=flat&logo=Swift&logoColor=ffffff"/>
<img src="https://img.shields.io/badge/Firebase-yellow?style=flat&logo=FireBase&logoColor=0c2a31"/> <img src="https://img.shields.io/badge/CoreData-orange?style=flat&logo=Swift&logoColor=ffffff"/>

## 🧑 팀원
<img src = "https://i.imgur.com/FixFdi0.jpg" width="200" height="200">|<img src = "https://i.imgur.com/0YI1hEB.jpg" width="200" height="200">|
|:--:|:--:|
|[Kiwi](https://github.com/kiwi1023)|[그루트](https://github.com/Groot-94)|

## 📱 실행 화면

|비밀번호 입력|달력|리스트|
|:--:|:--:|:--:|
|<img src = "https://i.imgur.com/XghAhiS.gif" width="250">|<img src = "https://i.imgur.com/QG5juhL.gif" width="250">|<img src = "https://i.imgur.com/xbeIFF9.gif" width="250">|

|일기 추가|일기 수정/삭제|일기 메뉴화면|
|:--:|:--:|:--:|
|<img src = "https://i.imgur.com/CZkjqao.gif" width="250">|<img src = "https://i.imgur.com/4gmDikl.gif" width="250">|<img src = "https://i.imgur.com/LvVZy7u.gif" width="250">|

|관심|설정|
|:--:|:--:|
|<img src = "https://i.imgur.com/qph5PiT.gif" width="250">|<img src = "https://i.imgur.com/oYsVULk.gif" width="250">|

## 👀 고민한 점
<details>
    
**<summary>Clean Architecture를 왜 사용하는가에 대한 의문이 생겼습니다.**
    
</summary>
    
- Testable한 코드를 만들기 위해 MVVM을 알아보던 중 Clean Architecture를 함께 쓰는 관련 글이 많이 있었습니다.
    
- MVVM과 Clean Architecture가 어떤 이유로 함께 사용되는지에 대한 의문이 생겨 회의를 진행했습니다.
    
- Clean Architecture를 사용함으로써 MVVM의 Model 부분을 세분화해서 코드를 분리할 수 있었습니다. 
    
- 각 특성에 맞는 역할만을 수행하도록 분리해주면 모델부분의 코드들이 변화와 확장에 열려있게 되기 때문에 유지보수에 용이할 수 있음을 알게 되었습니다.
    
- 이런 장점을 학습하기 위해 기존 CoreData와 새롭게 Firebase를 추가하여 로컬과 리모트 DB를 함께 사용할 수 있도록 리팩토링을 진행했습니다.
    
</details> 

<details> 
    
**<summary>REST_API의 Get을 통해 다수의 셀에 이미지를 설정해줘야 하는 부분에서 셀 재사용 시 기존 Reqeust를 취소 처리하는 방법을 고민했습니다.**
    
</summary>
    
- CompletionHandler 방식을 사용할 때 Task를 cancel하는 메서드가 있었지만, Combine을 사용해야 하는 상황에선 cancel을 호출할 수 없었습니다.

- Combine 학습을 통해 AnyCancellable을 취소하는 것으로 구독이 종료되고 구독에 의한 요청이 취소됨을 알 수 있었습니다.
    
-  Cell의 prepareForReuse()에서 image를 요청하는 AnyCancellable을 모두 제거해주는 방법으로 reqeust 취소를 구현했습니다.

</details> 
    
<details>
    
**<summary>Controller와 View 간의 데이터 바인딩을 진행할때에 Combine사용에 대한 고민이 있었습니다.**
    
</summary>
    
- Controller 내부에서 사용자의 Action을 입력 받는 등의 데이터 바인딩처리 하는 것에 Combine을 이용하는 것은 무리가 없었습니다.
   
- 그러나 Controller 하위 View에서는 바인딩 처리를 어떠한 방법으로 할 것인가에 대한 고민이 생겼습니다.
 
- RxSwift같은 경우 RxCocoa와의 호환을 통한 데이터 바인딩하는 오퍼레이터가 존재하는 것으로 알고 있습니다. 그러나 Combine의 경우 SwiftUI의 사용을 전제하는 프레임워크이기 때문에 UIkit에서는 해당 기능을 하는 오퍼레이터가 존재하지 않는 것 같았습니다.

- 결국 Delegate 및 클로저를 통한 데이터 바인딩을 구현하였고, 앞으로 UIkit에서 해당 기능을 Combine을 통해 어떻게 구현하는지 학습예정입니다.
    
</details> 

## ❓ 트러블 슈팅

<details>

**<summary>초기에 설정한 useCase의 read 함수 반환타입이 [Diary] 타입이였으나, 추후에 Remote DB 사용 시 비동기로 데이터를 전달받기 때문에 데이터의 전달 타입을 비동기로 처리해야 하는 문제가 있었습니다.**
    
</summary>
    
- 시도
    - Combine을 사용해서 비동기 처리를 하기로 결정했기 때문에 Combine의 어떤 타입으로 값을 전달할 지 회의를 진행했습니다.
- 해결
    - Repository에서 값을 보낼 때 값의 비동기 처리와 Error 처리가 가능한 Future 타입을 사용하기로 결정했습니다.
    - 실제로 값을 리턴하는 형식은 외부에서 값을 전달하지 못하고, 여러 클라이언트에서 로직변경 없이 전달받을 수 있는 AnyPublisher 타입으로 변환해서 사용했습니다.

</details> 
   
<details>

**<summary>textView의 높이를 내용에 맞게 변경할 때 constraint의 충돌문제가 있었습니다.** 
    
</summary>

- 시도
    - textView의 높이를 일정한 높이까지만 늘리고 그 후엔 스크롤이 가능하도록 구현하려 했습니다.
    - 최고높이 도달 후 고정하기 위해 constraint를 설정했습니다. 그 후 다시 줄이고 늘이는 과정 반복 시 새로운 constraint와 기존 constraint의 충돌로 인해 경고가 발생하는 문제가 있었습니다.
- 해결
    - 최고높이 도달 시 마지막 constraints을 확인, firstAttribute가 height일 시 기존 constraint을 지우고 새롭게 설정해주는 방법으로 해결했습니다.
    ![](https://i.imgur.com/x76PMTg.png)
</details>
<details>
    
**<summary>비밀 번호가 설정되어 있을 때 foreGround 진입시 이전 뷰와 상관없이 비밀번호 입력 창을 띄워야 하는 문제**

</summary>

- 시도
    - 앱이 Foreground 상태 진입시 SceneDelegate(sceneWillEnterForeground)에서 NotificationCenter를 이용해 비밀번호 입력 창을 띄워야 한다고 생각하였습니다. 그러나 이 경우 모든 ViewController에서 해당 NotificationCenter를 observe하고 있어하는데 만약 viewcontroller의 갯수가 수백개라면 모든 viewcontroller에서 observe 코드를 작성해야 하나 고민이 생겼습니다.
- 해결
    - 우려와는 달리 최상위 viewController에서만 notificationCenter를 구독하면 하위 플로우의 모든 뷰들은 해당 noti를 구독하게 되어 한번만 구독 코드를 작성해주면 된다는 사실을 알게 되었습니다.

    ![](https://i.imgur.com/unGX1YA.png)
(캘린더 뷰 이하 플로우 뷰는 자동으로 비밀번호 입력창을 띄우게 됨, 상위 플로우 뷰는 안띄움)
</details> 

## 🔗 참고 링크

- https://github.com/kudoleh/iOS-Clean-Architecture-MVVM
- https://developer.apple.com/documentation/combine
- https://zeddios.tistory.com/925
---

[🔝 맨 위로 이동하기](#-mongsil)
