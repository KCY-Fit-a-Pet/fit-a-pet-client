import Foundation

class DateFormatterUtils {

   static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
    }()
    
    static func formatDateString(_ dateString: String) -> String? {
        if let date = dateFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
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
    static func formatTotalDate(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale =  Locale(identifier: "ko_KR")
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "M월 d일"
            let datePart = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "E"
            let dayOfWeek = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "a h:mm"
            let timePart = dateFormatter.string(from: date)
            
            return "\(datePart)(\(dayOfWeek)) \(timePart)"
        }
        return nil
    }
}

