struct Categories{
    let categoryName: String
    let id: Int
}

struct CareDate{
    let week: String
    var time: String
}

extension CareDate{
    static var commonData: [CareDate] = []
    static var eachData: [CareDate] = []
}

