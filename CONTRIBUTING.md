# 기여 가이드라인

BedTimer 프로젝트에 기여해주셔서 감사합니다! 이 문서는 프로젝트에 기여하는 방법을 설명합니다.

## 🚀 시작하기

### 개발 환경 설정
1. Xcode 16.0+ 설치
2. 저장소 포크 및 클론
3. 워크스페이스 열기: `open BedTimer.xcworkspace`
4. 의존성 설치: `cd Tooling/fastlane && bundle install`

### 브랜치 전략
- `main`: 항상 릴리즈 가능한 상태
- `feat/<scope>`: 새로운 기능
- `fix/<scope>`: 버그 수정
- `chore/<scope>`: 유지보수 작업

## 📝 커밋 컨벤션

Conventional Commits 형식을 따릅니다:

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### 타입
- `feat`: 새로운 기능
- `fix`: 버그 수정
- `docs`: 문서 변경
- `style`: 코드 스타일 변경 (포맷팅 등)
- `refactor`: 리팩토링
- `test`: 테스트 추가/수정
- `chore`: 빌드 과정 또는 보조 도구 변경

### 예시
```
feat(alarm): add snooze functionality
fix(watch): resolve haptic feedback issue
docs(readme): update installation instructions
```

## 🔍 코드 리뷰 프로세스

### Pull Request 요구사항
1. **최소 1명의 승인** 필요
2. **모든 CI 검사 통과** (단위 테스트, UI 테스트, 린트)
3. **PR 템플릿 체크리스트** 완료

### PR 템플릿 체크리스트
- [ ] 단위 테스트 추가/수정
- [ ] UI 테스트 추가/수정
- [ ] 영어 + 한국어 로컬라이제이션
- [ ] 접근성 검증 (VoiceOver, Dynamic Type)
- [ ] 디자인 스펙 준수
- [ ] 코드 리뷰 완료

## 🧪 테스팅

### 테스트 작성 원칙
- **TDD**: 핵심 로직 (타이머, 기록)에 대해 TDD 적용
- **코드 커버리지**: 핵심 모듈 80% 이상
- **스냅샷 테스트**: UI 컴포넌트에 적용

### 테스트 실행
```bash
# 모든 테스트
xcodebuild -workspace BedTimer.xcworkspace -scheme BedTimer test

# 특정 테스트 타겟
xcodebuild -workspace BedTimer.xcworkspace -scheme BedTimerKit test
```

## 🎨 코딩 표준

### Swift 스타일
- Swift 5.10+, async/await 사용
- Sendable 적절히 사용
- SwiftLint + SwiftFormat 적용

### 네이밍 컨벤션
- Views: `ThingView`
- ViewModels: `ThingVM`
- Repositories: `ThingRepository`
- 모듈은 기능별로 구성 (Sessions/Alarm/Widgets)

### 아키텍처
- **MVVM + Repository 패턴** 사용
- 의존성 주입은 프로토콜을 통해
- 에러 처리: 타입화된 에러, 사용자에게 보이는 에러는 로컬라이즈

## 🌐 로컬라이제이션

### 다국어 지원
- **영어 우선** UI 및 코드
- 한국어 번역 제공
- 새로운 문자열 추가 시 두 언어 모두 업데이트

### 로컬라이제이션 작업
```bash
# 문자열 파일 생성
./Tooling/scripts/gen_strings.sh

# 번역 검증
xcodebuild -workspace BedTimer.xcworkspace -scheme BedTimer -destination 'platform=iOS Simulator,name=iPhone 15' -testLanguage ko test
```

## ♿ 접근성

### 요구사항
- VoiceOver 라벨 제공
- Dynamic Type AA 등급 통과
- 햅틱 피드백 제공
- 색상 대비 충족

### 검증 방법
1. Xcode Accessibility Inspector 사용
2. 실제 기기에서 VoiceOver 테스트
3. Dynamic Type 크기 변경 테스트

## 🚀 릴리즈 프로세스

### 버전 관리
- **SemVer** (MAJOR.MINOR.PATCH) 사용
- 태그 생성: `git tag vX.Y.Z`
- CI를 통한 자동 TestFlight 배포

### 릴리즈 체크리스트
- [ ] 버전 번호 업데이트
- [ ] CHANGELOG.md 업데이트
- [ ] 모든 테스트 통과
- [ ] 접근성 검증 완료
- [ ] 로컬라이제이션 검증 완료

## 🐛 버그 리포트

버그를 발견하셨나요? 다음 정보를 포함해주세요:

1. **버그 설명**: 무엇이 잘못되었나요?
2. **재현 단계**: 어떻게 재현할 수 있나요?
3. **예상 동작**: 어떻게 동작해야 하나요?
4. **실제 동작**: 실제로 어떻게 동작하나요?
5. **환경 정보**: iOS 버전, 기기 모델, 앱 버전
6. **스크린샷**: 가능하다면 스크린샷 첨부

## 💡 기능 요청

새로운 기능을 제안하고 싶으신가요?

1. **기능 설명**: 어떤 기능을 원하시나요?
2. **사용 사례**: 언제, 어떻게 사용하시겠나요?
3. **대안**: 다른 해결책을 고려해보셨나요?
4. **우선순위**: 얼마나 중요한가요?

## 📞 문의

- **이슈**: [GitHub Issues](https://github.com/your-username/bedtimer/issues)
- **토론**: [GitHub Discussions](https://github.com/your-username/bedtimer/discussions)

## 📜 행동 강령

이 프로젝트는 [Contributor Covenant](https://www.contributor-covenant.org/) 행동 강령을 따릅니다. 참여하시면 이 강령을 준수하는 것에 동의하는 것입니다.

---

기여해주셔서 다시 한 번 감사합니다! 🎉