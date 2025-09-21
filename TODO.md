# BedTimer TODO

## MVP Setup
- [ ] Configure `Config/Dev.xcconfig`, `Config/Staging.xcconfig`, `Config/Prod.xcconfig` with bundle identifiers and feature toggles
  - 설명: 환경별(개발/스테이징/배포)로 앱 이름과 번들 ID, 서버 주소 같은 값을 나눠 적어 두는 설정 파일이에요. 이렇게 해두면 실수로 잘못된 계정으로 배포하는 일을 막을 수 있어요.
- [ ] Define `FeatureFlags.plist` default values for Free vs Free+ tiers
  - 설명: 기능 스위치를 모아둔 파일입니다. 무료 사용자에겐 광고만 켜고, Free+ 사용자에겐 클라우드 동기화를 켜는 식으로 기본값을 구분해 둘 거예요.
- [ ] Populate `Tooling/scripts` with executable permissions and document usage
  - 설명: 버전 올리기나 문자열 추출 같은 반복 작업을 자동으로 해주는 스크립트에 실행 권한을 주고, 어떻게 쓰는지 간단한 설명을 함께 남겨요.

## Core App
- [x] Wire `BedTimerApp` with SwiftData `ModelContainer` for `BedSession`
  - 설명: 앱이 켜질 때 침대 세션 데이터를 저장하고 불러올 준비를 끝내도록 기본 저장소를 연결했어요.
- [x] Build Home view showing today's alarm, countdown state, and session summary
  - 설명: 첫 화면에서 최근 세션을 보고 새 세션을 시작하거나 종료할 수 있는 기본 UI를 만들었어요.
- [x] Implement session CRUD flows through `SessionRepository`
  - 설명: 세션을 만들고, 수정하고, 삭제하고, 최근 목록을 가져오는 기능을 한곳에 모아뒀어요.
- [x] Add notification permission onboarding and test-alarm trigger
  - 설명: 알림 권한을 받지 못하면 앱이 제 역할을 하지 못하므로, 권한 요청 안내와 테스트용 알람 버튼을 준비할 거예요.
- [x] Polish UI with onboarding tips, countdown progress, and session detail sheet
  - 설명: 실제 사용자가 보기 좋도록 화면 디자인을 다듬고, 남은 시간 시각화나 세션 상세 정보를 보여주는 화면을 추가할 계획이에요.

## Watch & Widgets
- [ ] Scaffold Watch app entry point mirroring session controls
  - 설명: 애플워치에서도 같은 세션 시작/종료 버튼을 쓸 수 있게 기본 화면을 마련할 계획이에요.
- [ ] Add WidgetKit extension with countdown widget placeholder
  - 설명: 홈 화면 위젯에서 남은 시간이나 최근 세션 정보를 간단히 볼 수 있도록 뼈대를 만들어 둘 거예요.

## Tooling & QA
- [ ] Add initial XCTest coverage for `SessionRepository`
  - 설명: 세션 저장소가 제대로 동작하는지 자동으로 검사하는 테스트 코드를 만들어 두면, 나중에 코드를 바꿀 때도 안심할 수 있어요.
- [ ] Integrate SwiftLint/SwiftFormat configs and pre-commit hook (optional)
  - 설명: 코드를 저장할 때 자동으로 스타일을 맞추고 잘못된 습관을 잡아주는 도구를 적용하면 팀 전체 품질이 올라가요.
- [ ] Verify GitHub Actions macOS build once project compiles
  - 설명: 깃허브에서 자동 빌드를 돌려서 다른 사람이 코드를 받아도 항상 빌드가 성공하도록 확인할 거예요.
