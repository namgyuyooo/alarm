# BedTimer

BedTimer는 깨어난 후 침대에 머물러 있는 시간을 줄이기 위한 미니멀한 알람 컴패니언 앱입니다. iPhone 알람, Apple Watch 빠른 상호작용, 위젯/컴플리케이션, 그리고 클라우드 동기화된 기록 추적을 결합합니다.

## 🚀 주요 기능

### 알람 및 알림
- iOS 로컬 알람과 알림 액션: 카운트다운 시작, 스누즈, 침대에서 나가기
- Live Activity (Dynamic Island/잠금 화면)에서 카운트다운 진행률 표시

### 침대 세션 추적
- 시작 → 인지된 시간
- 종료 → 침대에서 나간 시간  
- 목표 지속시간 vs 실제 머무른 시간
- 기록 삭제 (단일 세션 또는 일괄)

### Apple Watch 지원
- 큰 Start/Out/Snooze 버튼이 있는 Watch 앱
- 피드백을 위한 햅틱
- 카운트다운을 위한 컴플리케이션 (모서리, 원형, 인라인)
- Siri 단축어: "Start BedTimer", "Stop BedTimer", "Delete last record"

### 위젯 (iOS)
- 소형: 남은 카운트다운
- 중형: 주간 평균
- 대형: 기록 연속, 빠른 액션

## 🏗️ 프로젝트 구조

```
BedTimer.xcworkspace
├─ Apps/
│  ├─ BedTimer/ (iOS)
│  └─ BedTimerWatch/ (watchOS)
├─ Features/
│  ├─ Sessions/ (기록, 삭제, 통계)
│  ├─ Alarm/ (알림, 라이브 액티비티)
│  ├─ Widgets/
│  └─ Settings/
├─ Packages/
│  ├─ BedTimerKit/ (SPM)
│  └─ BedTimerAds/ (SPM; 무료 버전만)
├─ Config/
├─ Resources/
└─ Tooling/
```

## 🛠️ 개발 스택

- **언어**: Swift 5+
- **프레임워크**: SwiftUI, SwiftData, WidgetKit, ClockKit, ActivityKit
- **알림**: UNUserNotificationCenter
- **동기화**: WatchConnectivity, CloudKit (v2)
- **CI/CD**: GitHub Actions → TestFlight
- **테스팅**: XCTest, 스냅샷 테스트

## 🚦 시작하기

### 요구사항
- Xcode 16.0+
- iOS 17.0+
- watchOS 10.0+
- Swift 5.10+

### 설치
1. 저장소 클론
```bash
git clone https://github.com/your-username/bedtimer.git
cd bedtimer
```

2. Xcode에서 워크스페이스 열기
```bash
open BedTimer.xcworkspace
```

3. 의존성 설치
```bash
cd Tooling/fastlane
bundle install
```

### 빌드
```bash
# iOS 앱 빌드
xcodebuild -workspace BedTimer.xcworkspace -scheme BedTimer build

# watchOS 앱 빌드  
xcodebuild -workspace BedTimer.xcworkspace -scheme BedTimerWatch build
```

### 테스트
```bash
# 모든 테스트 실행
xcodebuild -workspace BedTimer.xcworkspace -scheme BedTimer test

# Fastlane으로 테스트
cd Tooling/fastlane
bundle exec fastlane test
```

## 📱 배포

### TestFlight 배포
```bash
cd Tooling/fastlane
bundle exec fastlane beta
```

### App Store 배포
```bash
cd Tooling/fastlane
bundle exec fastlane release
```

## 🔧 개발 도구

### 버전 업데이트
```bash
./Tooling/scripts/bump_version.sh [major|minor|patch]
```

### 로컬라이제이션 문자열 생성
```bash
./Tooling/scripts/gen_strings.sh
```

## 📊 성공 지표

- **시작 전환율**: "일어났어"를 트리거하는 알람의 비율
- **종료 전환율**: "침대에서 나가기"를 기록하는 세션의 비율  
- **목표 달성률**: 목표를 달성하는 세션의 비율
- **4주 후 평균 머무름 시간 감소**
- **위젯/컴플리케이션 참여도** (조회수, 탭)

## 🤝 기여하기

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

자세한 내용은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참조하세요.

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 있습니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 🔒 보안

보안 취약점을 발견한 경우 [SECURITY.md](SECURITY.md)를 참조하여 신고해주세요.

## 📞 지원

문제가 있거나 질문이 있으시면 [Issues](https://github.com/your-username/bedtimer/issues)를 통해 문의해주세요.