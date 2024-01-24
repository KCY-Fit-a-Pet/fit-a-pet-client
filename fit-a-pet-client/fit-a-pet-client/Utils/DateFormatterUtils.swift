import Foundation

class DateFormatterUtils {
    static func formatTime(_ timeString: String, from format: String = "HH:mm:ss", to newFormat: String = "h:mm a") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: timeString) {
            dateFormatter.dateFormat = newFormat
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

