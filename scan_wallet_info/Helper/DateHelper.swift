//
//  DateHelper.swift
//  element3
//
//  Created by Zignuts Technolab on 17/09/19.
//  Copyright © 2019 Zignuts Technolab (Sudhir Patel). All rights reserved.
//

import Foundation
class DateHelper: NSObject {
    static let currentTimeZone = TimeZone.current.identifier
    static let globleTimeZone = "GMT"
    
    //MARK:- CONVERT TO MILLISECOND TO DATE AND VICE-VERSA
    static func currentTimeInMiliseconds(currentDate:Date = Date()) -> Int {
        let since1970 = currentDate.timeIntervalSince1970
        return Int(since1970 * 1000)
    }
    
    static func dateFromMilliseconds(milisecond:Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(milisecond)/1000)
    }
 
    
    //MARK:- STRING TO STRING
    static func getFormatedDateString(fromDate:String, fromFormate:String, ToFormate:String, fromTimeZone:String, toTimezone:String) -> String{
        let formater = DateFormatter()
        formater.timeZone = TimeZone(identifier: fromTimeZone)
        formater.dateFormat = fromFormate
        if let serverDate = formater.date(from: fromDate){
            formater.dateFormat = ToFormate
            formater.timeZone = TimeZone(identifier: toTimezone)
            return formater.string(from: serverDate)
        }
        return fromDate
    }
    
    static func getFormatedStringFromDate(Date2Formate:Date, strFormate:String, timezone:String = (TimeZone.current.identifier)) -> String {
        let dFormater = DateFormatter()
        dFormater.dateFormat = strFormate
        dFormater.timeZone = TimeZone.init(identifier: timezone)
        return dFormater.string(from: Date2Formate)
    }
    
     //MARK:- STRING TO DATE
    static func convertGetDateFromJson(fromDate:String, fromFormate:String, ToFormate:String) -> Date?{
        let formater = DateFormatter()
        formater.timeZone = TimeZone(identifier: "UTC")
        formater.dateFormat = fromFormate
        if let serverDate = formater.date(from: fromDate){
            formater.dateFormat = ToFormate
            let strdate = formater.string(from: serverDate)
            return formater.date(from: strdate)
        }
        return nil
    }
    
    //MARK:- Date TO DATE
    static func formatedDateToDateWithoutTime(date:Date, timeZone:String) -> Date {
        let dateFormate = DateFormatter()
        dateFormate.dateStyle = .long
        dateFormate.timeStyle = .none
        dateFormate.timeZone = TimeZone(identifier: timeZone)
        let strDate = dateFormate.string(from: date)
        return dateFormate.date(from: strDate) ?? date
    }
    //MARK: - MILLISECOND TO DDATE
    static func getDorametdDateFromMilliSeconds(milSec:Int, toFormate:String, toTimeZone:String) -> String {
        let date = DateHelper.dateFromMilliseconds(milisecond: milSec)
        return formatedStringFromDate(Date2Formate: date, strFormate: toFormate, timezone: toTimeZone)
    }
    
    // MARK: - DATE ACTIONS
    static func getDate(byAddingDay:Int, toDate:Date) -> Date? {
        return Calendar.current.date(byAdding: Calendar.Component.day, value: byAddingDay, to: toDate)
    }
    
    static func getWeekDays(ForDate:Date)->(startDate:Date, endDate:Date)?{
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: ForDate)
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        var days = [Date]()
        for value in (weekdays.lowerBound + 1 ... weekdays.upperBound) {
            if let date = calendar.date(byAdding: .day, value: value - dayOfWeek, to: today) {
                days.append(date)
            }
        }
        
        if let startDate = days.first , let endDate = days.last{
            return (startDate, endDate)
        }
        return nil
    }
    
    static func getMonth(byAddingDay:Int, toDate:Date) -> Date? {
        return Calendar.current.date(byAdding: Calendar.Component.month, value: byAddingDay, to: toDate)
    }
    
    static func getMonthStartDate(forDate:Date) -> Date {
        let components = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month], from: forDate)
        if let startOfMonth = Calendar.current.date(from: components){
            return startOfMonth
        }
        return forDate
    }
    
    
    
//    static func getFormatedStartEndDate(strStartDate_Time:String, strEndDate_Time:String) -> String{
//        var endDate = ""
//        var startDate = ""
//        let dateFormat = DateFormatter()
//        dateFormat.dateFormat = APPDateFormates.serverFormate
//        if let dte = dateFormat.date(from: strStartDate_Time) {
//            dateFormat.dateFormat = APPDateFormates.shortDDMMMYYYY
//            startDate = dateFormat.string(from: dte)
//        }
//        
//        dateFormat.dateFormat = APPDateFormates.serverFormate
//        if let dte = dateFormat.date(from: strEndDate_Time) {
//            dateFormat.dateFormat = APPDateFormates.shortDDMMMYYYY
//            endDate = dateFormat.string(from: dte)
//        }
//        return "\(startDate) to \(endDate)"
//    }
    
    static func getFormatedStartEndDateTime(strStartDate_Time:String, strEndDate_Time:String)-> (Date:String,Time:String){
        var endDate = ""
        var startDate = ""
        var endTime = ""
        var startTime = ""
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = APPDateFormates.serverFormate
        if let dte = dateFormat.date(from: strStartDate_Time) {
            dateFormat.dateFormat = APPDateFormates.shortDDMMYYYY
            startDate = dateFormat.string(from: dte)
            
            dateFormat.dateFormat = "hh:mm a"
            startTime = dateFormat.string(from: dte)
        }
        
        dateFormat.dateFormat = APPDateFormates.serverFormate
        if let dte = dateFormat.date(from: strEndDate_Time) {
            dateFormat.dateFormat = APPDateFormates.shortDDMMYYYY
            endDate = dateFormat.string(from: dte)
            
            dateFormat.dateFormat = "hh:mm a"
            endTime = dateFormat.string(from: dte)
        }
        let date2send = "\(startDate) to \(endDate)"
        let time2send = "\(startTime) to \(endTime)"
        return (date2send, time2send)
    }
}
