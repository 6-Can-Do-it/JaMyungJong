# ⏰ JamyoungJong(자명종)

JamyoungJong은 사용자가 아침을 긍정적으로 시작하고, 일상적인 시간 관리를 효율적으로 할 수 있도록 돕는 알람, 스톱워치, 타이머 기능을 통합한 앱입니다.

## 🙆‍♂️ 팀원

| [![최성준](https://avatars.githubusercontent.com/u/185742428?v=4)](https://github.com/Choi-jun08) | [![김동글](https://avatars.githubusercontent.com/u/185791318?v=4) | [![양정무](https://avatars.githubusercontent.com/u/105642388?v=4)](https://github.com/jeongmuya) | [![이진욱](https://avatars.githubusercontent.com/u/137531787?v=4)](https://github.com/jwl-98) | [![황석범](https://avatars.githubusercontent.com/u/49748207?v=4)](https://github.com/HwangSeokBeom) |
|:---:|:---:|:---:|:---:|:---:|
|[최성준](https://github.com/Choi-jun08) |[김동글](https://github.com/nemo-semo)|[양정무](https://github.com/jeongmuya)|[이진욱](https://github.com/jwl-98)|[황석범](https://github.com/HwangSeokBeom)|
|미션화면|스톱워치|메인 화면 |알람상세화면|타이머|

## 🎥 시연 영상
| ![화면 기록 2025-01-15 오후 5 26 32](https://github.com/user-attachments/assets/ad30c98f-1409-41e7-8e88-34513b9b027e) | ![화면 기록 2025-01-15 오후 5 27 19](https://github.com/user-attachments/assets/511e8670-cda3-41a9-b667-22f6f434400d) | ![화면 기록 2025-01-15 오후 5 23 51](https://github.com/user-attachments/assets/c941a81f-6c5c-4054-bae9-bd614ae3e3d7) | ![화면 기록 2025-01-15 오후 5 24 19](https://github.com/user-attachments/assets/1d961ed6-70b1-488a-9b35-bf72dd77c9f0) |
|:---:|:---:|:---:|:---:|
| 알람 설정 | 미션, 메인 화면 | 스톱워치 | 타이머 |

## 🎯 프로젝트 목표 및 개발 의도

1. **사용자 친화적인 알람 앱 제공**  
   - 아침에 일어나기 어려운 사용자들을 위해, 단순히 알람을 끄는 것을 넘어 더 효과적으로 기상하도록 돕는 기능 제공.

2. **일상적인 시간 관리 도구로 활용**  
   - 알람뿐만 아니라 **스톱워치**와 **타이머** 기능을 추가하여 다양한 상황에서 활용 가능.

3. **직관적인 사용자 경험(UI/UX) 제공**  
   - 깔끔하고 직관적인 UI를 통해 사용자가 빠르고 쉽게 앱을 조작할 수 있도록 설계.

4. **긍정적인 하루 시작 유도**  
   - 알람 해제 후 **동기부여 메시지**와 **실시간 날씨 정보**를 제공하여 하루를 긍정적으로 시작하도록 지원.

---

## ⏰ 프로젝트 기간
- 시작일: 2025/01/07(화)
- 종료일: 2025/01/15(수)

## 📋 주요 기능

1. **알람 설정 및 관리**
   - 요일별 반복 알람 설정 가능.
   - 다양한 알람 소리 지원.
   - 미션 기반 알람 해제(퀴즈, 간단한 문제 풀기 등).

2. **스톱워치**
   - 시간을 정확히 측정할 수 있는 스톱워치 기능 제공.
   - 랩 타임 기록 및 공유 가능.

3. **타이머**
   - 간단한 타이머 설정과 관리.
   - 최근 사용한 타이머 기록 저장.

4. **날씨 정보 제공**
   - 아침에 기상 시 현재 날씨와 하루 예보 제공.

5. **동기부여 메시지**
   - 알람 해제 후 하루를 시작하는 데 도움을 주는 긍정적인 메시지 표시.

---

## 🛠️ 기술 스택

- **언어**: Swift
- **구조**: UIKit, MVC
- **라이브러리**: SnapKit (UI 레이아웃), AVFoundation ( 알람 소리 ), userNotifications ( 로컬 알림 및 알람 )
- **프레임워크**: Core Data (데이터 저장), Userdefaults (데이터 저장), AudioToolbox (알람 소리)

---

## 📂 프로젝트 구조

```
JamyoungJong
├── App
│   └── AppDelegate.swift                      # 앱 시작 시 초기화 및 설정 관리
├── Helpers
│   └── Constants.swift                        # 상수 정의
├── MainView
│   ├── Configuration.swift                   # 앱 설정 관련 구성
│   ├── ForecastWeatherResult.swift           # 날씨 API 결과 모델
│   ├── MorningViewController.swift           # 아침 알람 메인 화면
│   ├── TableViewCell.swift                   # 테이블 뷰 셀 설정
│   ├── WeatherModel.swift                    # 날씨 데이터 모델
│   └── WeatherViewController.swift           # 날씨 정보 화면 컨트롤러
├── Mission
│   ├── MissionViewController.swift           # 미션 화면 컨트롤러
│   └── QuestionModel.swift                   # 미션 질문 모델
├── SetAlarmView_JW
│   ├── Controllers
│   │   ├── AlarmListViewController.swift     # 알람 목록 화면 컨트롤러
│   │   └── SetAlarmViewController.swift      # 알람 설정 화면 컨트롤러
│   ├── Models
│   │   └── AlarmData.swift                   # 알람 데이터 모델
│   └── Views
│       ├── AlarmDetailSetView
│       │   ├── DaySetView.swift              # 요일 설정 화면
│       │   ├── SettingMainView.swift         # 메인 설정 화면
│       │   └── SoundSetView.swift            # 알람 소리 설정 화면
│       └── AlarmListView
│           └── AlarmListCell.swift           # 알람 리스트 셀 뷰
├── Sounds
│   └── 기본 알람 소리 파일 및 리소스
├── StopWatch
│   ├── StopWatchModel.swift                  # 스톱워치 데이터 모델
│   ├── StopWatchView.swift                   # 스톱워치 UI 뷰
│   └── StopWatchViewController.swift         # 스톱워치 화면 컨트롤러
├── TabBarController
│   └── TabBarController.swift                # 탭 바 컨트롤러 설정
├── Timer
│   ├── Cell
│   │   ├── RecentTimerCell.swift             # 최근 타이머 셀
│   │   ├── SoundCell.swift                   # 타이머 사운드 셀
│   │   └── TimerCell.swift                   # 타이머 셀
│   ├── Common
│   │   ├── CoreDataManager.swift             # Core Data 관리
│   │   ├── NotificationManager.swift         # 알림 관리
│   │   └── SoundManager.swift                # 사운드 관리
│   ├── Model
│   │   ├── Sound.swift                       # 사운드 데이터 모델
│   │   └── TimerModel.swift                  # 타이머 데이터 모델
│   ├── View
│   │   ├── TimerDetailsView.swift            # 타이머 상세 뷰
│   │   └── TimerView.swift                   # 타이머 메인 뷰
│   └── ViewController
│       ├── SoundSelectionViewController.swift # 사운드 선택 화면 컨트롤러
│       ├── TimerDetailsViewController.swift   # 타이머 상세 화면 컨트롤러
│       └── TimerViewMainController.swift      # 타이머 메인 화면 컨트롤러
├── AlarmRingViewController.swift              # 알람 소리 재생 화면
├── Assets
│   └── 앱 리소스 (이미지, 아이콘 등)
├── default_ringtone                           # 기본 알람 소리 파일
├── Info                                       # 앱 정보 설정 파일
├── JamyoungJong.xcodeproj                     # Xcode 프로젝트 파일
├── LaunchScreen                               # 런치 스크린 설정
├── MainViewController.swift                   # 메인 화면 컨트롤러
├── Frameworks
│   └── AudioToolbox                          # 오디오 재생 관련 프레임워크
└── Package Dependencies
    └── SnapKit 5.7.1                         # UI 레이아웃 라이브러리
```

## 🔧 설치 및 실행 방법

1. 프로젝트 클론
```bash
git clone https://github.com/your-username/JamyoungJong.git
```

2. Pod 설치
```bash
pod install
```
