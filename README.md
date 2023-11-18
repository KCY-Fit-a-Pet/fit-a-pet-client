# Fit a Pet
김최양 사이드 프로젝트 FitaPet 프론트엔드 Repository 입니다.

- 기획&디자인: [김유빈](https://github.com/youvebeen09)
- 프론트엔드: [최희진](https://github.com/heejinnn)
- [백엔드](https://github.com/psychology50/fit-a-pet-server.git): [양재서](https://github.com/psychology50)

## Dev Environment
- Xcode
- GitHub
- Notion

## Tech Stack
### Framework
- uikit

### Library

- Alamofire
- SwiftyJSON
- Snapkit

### Architecture
- MVC     


(재서님꺼 줍줍)
## Branch Convention

```
main ── develop ── feature
└── hotfix
```

| Brach name | description |
| --- | --- |
| main | 배포 중인 서비스 브랜치
• 실제 서비스가 이루어지는 브랜치입니다.
• 해당 브랜치를 기준으로 develop 브랜치가 분기됩니다.
• 긴급 수정 안건에 대해서는 hotfix 브랜치에서 처리합니다. |
| develop | 작업 브랜치
• 개발, 테스트, 릴리즈 등 배포 전 단계의 기준이 되는 브랜치입니다.
• 프로젝트의 default 브랜치입니다.
• 해당 브랜치에서 feature 브랜치가 분기됩니다. |
| feature | 기능 단위 구현
• 개별 개발자가 맡은 작업을 개발하는 브랜치입니다.
• feature/(feature-name)처럼 머릿말-꼬릿말(개발하는 기능)으로 명명합니다.
• kebab-case 네이밍 규칙을 준수합니다. |
| hotfix | 서비스 중 긴급 수정 사항 처리
• main에서 분기합니다. |

## Commit Convention

| emoji | message | description |
| --- | --- | --- |
| :sparkles: | feat | 새로운 기능 추가, 기존 기능을 요구 사항에 맞추어 수정 |
| :bug: | fix | 기능에 대한 버그 수정 |
| :green_heart: | build | 빌드 관련 수정 |
| :pushpin: | chore | 패키지 매니저 수정, 그 외 기타 수정 ex) .gitignore |
| :construction_worker: | ci | CI 관련 설정 수정 |
| :closed_book: | docs | 문서(주석) 수정 |
| :art: | style | 코드 스타일, 포맷팅에 대한 수정 |
| :recycle: | refactor | 기능 변화가 아닌 코드 리팩터링 |
| :white_check_mark: | test | 테스트 코드 추가/수정 |
| :bookmark: | release | 버전 릴리즈 |
| :ambulance: | hotfix | 긴급 수정 |
| :twisted_rightwards_arrows: | branch | 브랜치 추가/병합 |
