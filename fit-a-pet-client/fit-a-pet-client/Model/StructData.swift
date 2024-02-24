import Foundation

//care 관련
struct Categories{
    var categoryName: String
    var id: Int
}

struct CareDate{
    let week: String
    var time: String
}

extension CareDate{
    static var commonData: [CareDate] = []
    static var eachData: [CareDate] = []
}


//schedule 관련
struct PetScheduleInfo: Codable {
    let petId: Int
    let petProfileImage: String
}

struct ScheduleData: Codable {
    let reservationDate: String
    let scheduleId: Int
    let scheduleName: String
    let location: String
    let pets: [PetScheduleInfo]
}

struct ScheduleListResponse: Codable {
    let status: String
    var data: ScheduleListData
}

struct ScheduleListData: Codable {
    var schedules: [ScheduleData]
}

struct SelectedDate {
    static var date: Date? = Date()
}
