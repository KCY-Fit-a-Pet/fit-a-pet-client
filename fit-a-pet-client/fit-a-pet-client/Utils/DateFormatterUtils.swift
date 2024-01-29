import Foundation

class DateFormatterUtils {
    static func formatTime(_ timeString: String, from format: String = "HH:mm:ss", to newFormat: String = "a h:mm") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale =  Locale(identifier: "ko_KR")
        
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = newFormat
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    static func formatFullDate(_ dateString: String, from format: String = "yyyy.MM.dd", to newFormat: String = "yyyy.MM.dd (E)") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale =  Locale(identifier: "ko_KR")
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = newFormat
            let formattedDate = dateFormatter.string(from: date)
            return formattedDate
        }
        return nil
    }
}

