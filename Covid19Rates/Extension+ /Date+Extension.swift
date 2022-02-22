//
//  Date Extension.swift
//  Covid19Rates
//
//  Created by Sezgin Çiftci on 7.02.2022.
//

import Foundation

extension String {
    
    func stringToDate(toString dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ssZ"
        let actualDate = dateFormatter.date(from: dateString)!
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = dateFormatter.string(from: actualDate)
        
        return date
    }
    
    func stringToDateToDouble(toDouble dateString: String) -> Double {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let actualDate = dateFormatter.date(from: dateString)!
        
        let timeInterval = actualDate.timeIntervalSinceReferenceDate
        
        return timeInterval
    }
}

extension Int {
    
    func IntToDecimals(number: Int) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .none
        let actualNumber = nf.number(from: String(number)) ?? 0
        nf.numberStyle = .decimal
        let stringNumber = nf.string(from: actualNumber)
        
        guard let stringNumber = stringNumber else {
            return ""
        }
        return stringNumber
    }
}


//private func test() -> String {
//    let nf = NumberFormatter()
//    nf.numberStyle = .none
//    let myNumber = nf.number(from: String(1234567))!
//    nf.numberStyle = .decimal
//    let number = nf.string(from: myNumber)
//
//    guard let number = number else { return ""}
//    return number
//}



//                let dateString = datas.all.updated
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ssZ"
//                let actualDate = dateFormatter.date(from: dateString)
//                let dateFormatter2 = DateFormatter()
//                dateFormatter2.dateFormat = "dd.MM.yyyy" //"YY, MMM d, HH:mm:ss"
//                let mydate = dateFormatter2.string(from: actualDate!)
