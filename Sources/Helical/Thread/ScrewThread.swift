import Foundation
import SwiftSCAD

public struct ScrewThread: Sendable {
    public let handedness: Handedness
    public let starts: Int
    public let pitch: Double
    public let majorDiameter: Double
    public let minorDiameter: Double
    let form: any ThreadForm

    public var depth: Double { (majorDiameter - minorDiameter) / 2 }
    public var lead: Double { Double(starts) * pitch }
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

    public enum Handedness: Sendable {
        case right
        case left
    }
}

public protocol ThreadForm: Sendable {
    func shape(for thread: ScrewThread) -> Polygon
    func pitchDiameter(for thread: ScrewThread) -> Double
}
