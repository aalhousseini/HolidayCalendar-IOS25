//
//  HolidayCalendarWidgetBundle.swift
//  HolidayCalendarWidget
//
//  Created by Al Housseini, Ahmad on 22.01.25.
//

import WidgetKit
import SwiftUI

@main
struct HolidayCalendarWidgetBundle: WidgetBundle {
    var body: some Widget {
        HolidayCalendarWidget()
        HolidayCalendarWidgetControl()
        HolidayCalendarWidgetLiveActivity()
    }
}
