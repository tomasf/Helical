import Foundation
import Cadova

/// Describes a helical screw thread with geometric parameters and profile form.
public struct ScrewThread: Sendable {
    /// Thread handedness (right- or left-hand).
    public let handedness: Handedness
    /// Number of thread starts.
    public let starts: Int
    /// Axial distance between adjacent thread flanks.
    public let pitch: Double
    /// Outside diameter measured crest-to-crest.
    public let majorDiameter: Double
    /// Root diameter measured root-to-root.
    public let minorDiameter: Double
    let form: any Threadform

    /// Radial height of the thread from root to crest.
    public var depth: Double { (majorDiameter - minorDiameter) / 2 }
    /// Axial advance per revolution.
    public var lead: Double { Double(starts) * pitch }
    var leftHanded: Bool { handedness == .left }
    var pitchDiameter: Double { form.pitchDiameter(for: self) }

    /// Creates a screw thread with the specified geometry and profile form.
    ///
    /// - Parameters:
    ///   - handedness: Thread handedness. Defaults to right-hand.
    ///   - starts: Number of thread starts. Defaults to 1.
    ///   - pitch: Axial distance between adjacent thread flanks.
    ///   - majorDiameter: Outside diameter measured crest-to-crest.
    ///   - minorDiameter: Root diameter measured root-to-root.
    ///   - form: The thread profile form.
    ///   
    public init(handedness: Handedness = .right, starts: Int = 1, pitch: Double, majorDiameter: Double, minorDiameter: Double, form: any Threadform) {
        self.handedness = handedness
        self.starts = starts
        self.pitch = pitch
        self.majorDiameter = majorDiameter
        self.minorDiameter = minorDiameter
        self.form = form

        let minPitch = form.minimumPitch(for: self)
        assert(pitch >= minPitch, "Thread pitch (\(pitch)) is smaller than the minimum (\(minPitch)) required by the threadform. Adjacent thread turns will overlap.")
    }

    /// Indicates the handedness of a thread.
    public enum Handedness: Sendable {
        /// Right-hand thread.
        case right
        /// Left-hand thread.
        case left
    }

    /// A degenerate thread with no profile (cylindrical shank).
    ///
    /// - Parameter diameter: Cylinder diameter.
    /// - Returns: A thread where major and minor diameters are equal.
    public static func none(diameter: Double) -> Self {
        Self(pitch: 1, majorDiameter: diameter, minorDiameter: diameter, form: SolidThreadform())
    }
}

/// Describes a 2D thread profile capable of providing pitch diameter.
public protocol Threadform: Shape2D {
    /// Returns the pitch diameter for the given thread.
    func pitchDiameter(for thread: ScrewThread) -> Double

    /// Returns the minimum pitch that this threadform requires for the given thread.
    ///
    /// When the actual pitch is smaller than this value, adjacent thread turns overlap
    /// and produce invalid geometry.
    func minimumPitch(for thread: ScrewThread) -> Double
}

extension Threadform {
    var innerInset: Double { 0.001 }
}
