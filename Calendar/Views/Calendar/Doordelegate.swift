//
//  Doordelegate.swift
//  Calendar
//
//  Created by Al Housseini, Ahmad on 17.01.25.
//

import SwiftUI

struct DoorDropDelegate: DropDelegate {
    let item: Door
    @Binding var current: Door?
    @Binding var doors: [Door]

    func dropEntered(info: DropInfo) {
        guard let current = current,
              current.id != item.id,
              let fromIndex = doors.firstIndex(of: current),
              let toIndex = doors.firstIndex(of: item) else { return }

        withAnimation {
            doors.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
        }
    }

    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}
