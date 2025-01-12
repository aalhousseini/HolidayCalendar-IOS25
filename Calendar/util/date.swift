//
//  date.swift
//  Holiday Calendar
//
//  Created by Al Housseini, Ahmad on 09.01.25.
//


import Foundation


struct dateLocal {
    
    func getDate() -> String {
        let currentDate: Date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM yy" 
//        formatter.timeStyle = .none
//        formatter.dateStyle = .short
        return formatter.string(from: currentDate)
      
    }
    
    
    
}

