
struct MyInfo {
    var id : Int
    let cellTitle : String
    let userData: String
}

extension MyInfo{
    static let cellList: [MyInfo] = [
        MyInfo(id: 1, cellTitle: "간편 로그인", userData: "abcd1234@mail.com"),
        MyInfo(id: 2, cellTitle: "아이디", userData: "abcd1234"),
        MyInfo(id: 3, cellTitle: "비밀번호 변경", userData: ""),
        MyInfo(id: 4, cellTitle: "전화번호",userData: "010-1234-1234")
    ]
}


struct AlarmSegment {
    var id : Int
    let cellTitle : String
    let cellSubTitie : String
    let alarmToggle: Int
}

extension AlarmSegment{
    static let cellList: [AlarmSegment] = [
        AlarmSegment(id: 1, cellTitle: "케어 알림", cellSubTitie: "예정된 케어, 완료되지 않은 케어를 알려드려요.", alarmToggle: 0 ),
        AlarmSegment(id: 2, cellTitle: "일기 알림", cellSubTitie: "새 일기기록이 생성되면 알려드려요.", alarmToggle: 1),
        AlarmSegment(id: 3, cellTitle: "일정 알림", cellSubTitie: "새로운 일정, 예정된 일정을 알려드려요.", alarmToggle: 1)
    ]
}
