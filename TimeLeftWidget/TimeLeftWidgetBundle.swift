//
//  TimeLeftWidgetBundle.swift
//  TimeLeftWidget
//
//  Created by Al Housseini, Ahmad on 26.01.25.
//

import WidgetKit
import SwiftUI

@main
struct TimeLeftWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimeLeftWidget()
        TimeLeftWidgetControl()
        TimeLeftWidgetLiveActivity()
    }
}
