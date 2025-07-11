import Foundation
import Cadova

public struct ScrewThread: Sendable {
    public let handedness: Handedness
    public let starts: Int
    public let pitch: Double
    public let majorDiameter: Double
    public let minorDiameter: Double
    let form: any Threadform

    public var depth: Double { (majorDiameter - minorDiameter) / 2 }
    public var lead: Double { Double(starts) * pitch }
    var leftHanded: Bool { handedness == .left }
    var pitchDiameter: Double { form.pitchDiameter(for: self) }

    public init(handedness: Handedness = .right, starts: Int = 1, pitch: Double, majorDiameter: Double, minorDiameter: Double, form: any Threadform) {
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

    public static func none(diameter: Double) -> Self {
        Self(pitch: 1, majorDiameter: diameter, minorDiameter: diameter, form: SolidThreadform())
    }
}

public protocol Threadform: Shape2D {
    func pitchDiameter(for thread: ScrewThread) -> Double
}
