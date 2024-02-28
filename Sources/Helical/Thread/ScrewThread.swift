import Foundation
import SwiftSCAD

struct ScrewThread {
    let handedness: Handedness
    let starts: Int
    let pitch: Double
    let majorDiameter: Double
    let minorDiameter: Double
    let form: any ThreadForm

    var depth: Double { (majorDiameter - minorDiameter) / 2 }
    var lead: Double { Double(starts) * pitch }
    var leftHanded: Bool { handedness == .left }
    var pitchDiameter: Double { form.pitchDiameter(for: self) }

    init(handedness: Handedness = .right, starts: Int = 1, pitch: Double, majorDiameter: Double, minorDiameter: Double, form: any ThreadForm) {
        self.handedness = handedness
        self.starts = starts
        self.pitch = pitch
        self.majorDiameter = majorDiameter
        self.minorDiameter = minorDiameter
        self.form = form
    }

    enum Handedness {
        case right
        case left
    }
}

protocol ThreadForm {
    func shape(for thread: ScrewThread, in environment: Environment) -> Polygon
    func pitchDiameter(for thread: ScrewThread) -> Double
}
