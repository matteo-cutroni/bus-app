//
//  BusTimeWidgetBundle.swift
//  BusTimeWidget
//
//  Created by Matteo Cutroni on 21/11/24.
//

import WidgetKit
import SwiftUI

@main
struct BusTimeWidgetBundle: WidgetBundle {
    var body: some Widget {
        BusTimeWidget()
        BusTimeWidgetControl()
        BusTimeWidgetLiveActivity()
    }
}
