import Foundation
import SwiftSCAD

public struct ScrewThread {
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

    public init(handedness: Handedness = .right, starts: Int = 1, pitch: Double, majorDiameter: Double, minorDiameter: Double, form: any ThreadForm) {
        self.handedness = handedness
        self.starts = starts
        self.pitch = pitch
        self.majorDiameter = majorDiameter
        self.minorDiameter = minorDiameter
        self.form = form
    }

    public enum Handedness {
        case right
        case left
    }
}

public protocol ThreadForm {
    func shape(for thread: ScrewThread) -> Polygon
    func pitchDiameter(for thread: ScrewThread) -> Double
}
