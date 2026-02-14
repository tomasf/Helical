import Cadova

/// Specifies lead-in chamfers for both ends of a threaded feature.
///
/// Use this to configure which ends of a ``Screw``, ``ThreadedHole``, or ``Nut``
/// receive lead-in chamfers to ease thread engagement.
public struct LeadInEnds: Sendable {
    let leading: LeadIn?
    let trailing: LeadIn?

    init(leading: LeadIn?, trailing: LeadIn?) {
        self.leading = leading
        self.trailing = trailing
    }

    /// Different lead-in chamfers on each end.
    ///
    /// - Parameters:
    ///   - leading: The lead-in for the leading (min Z) end.
    ///   - trailing: The lead-in for the trailing (max Z) end.
    public static func asymmetric(leading: LeadIn, trailing: LeadIn) -> Self {
        .init(leading: leading, trailing: trailing)
    }

    /// The same lead-in chamfer on both ends.
    ///
    /// - Parameter chamfer: The lead-in to apply to both ends.
    public static func both(_ chamfer: LeadIn) -> Self {
        .init(leading: chamfer, trailing: chamfer)
    }

    /// A lead-in chamfer on the leading (min Z) end only.
    ///
    /// - Parameter chamfer: The lead-in to apply.
    public static func leading(_ chamfer: LeadIn) -> Self {
        .init(leading: chamfer, trailing: nil)
    }

    /// A lead-in chamfer on the trailing (max Z) end only.
    ///
    /// - Parameter chamfer: The lead-in to apply.
    public static func trailing(_ chamfer: LeadIn) -> Self {
        .init(leading: nil, trailing: chamfer)
    }

    /// Standard lead-in chamfers on both ends.
    public static var both: Self { .both(.standard) }
    /// A standard lead-in chamfer on the leading (min Z) end only.
    public static var leading: Self { .leading(.standard) }
    /// A standard lead-in chamfer on the trailing (max Z) end only.
    public static var trailing: Self { .trailing(.standard) }

    /// No lead-in chamfers on either end.
    public static var none: Self {
        .init(leading: nil, trailing: nil)
    }
}


/// A lead-in chamfer specification for easing thread engagement.
///
/// Defines the size of a chamfer at the end of a threaded feature.
/// The size can be specified as an absolute value, relative to the thread geometry,
/// or as a cone angle spanning the full thread depth.
public struct LeadIn: Sendable {
    let size: Size

    init(size: Size) {
        self.size = size
    }

    /// A lead-in sized as a multiple of the thread depth.
    ///
    /// - Parameter multiple: The multiplier applied to the thread depth.
    public static func depth(multiple: Double) -> Self {
        .init(size: .depth(multiple: multiple))
    }

    /// A lead-in with explicit depth and axial length.
    ///
    /// - Parameters:
    ///   - depth: The radial depth of the chamfer.
    ///   - length: The axial length of the chamfer.
    public static func constant(depth: Double, length: Double) -> Self {
        .init(size: .constant(depth: depth, length: length))
    }

    /// A 45° lead-in with explicit depth.
    ///
    /// - Parameter depth: The radial depth and axial length of the chamfer.
    public static func constant(depth: Double) -> Self {
        .init(size: .constant(depth: depth, length: depth))
    }

    /// A standard 45° lead-in chamfer of 1× thread depth.
    public static var standard: Self {
        .depth(multiple: 1)
    }

    /// A lead-in sized as a multiple of the thread pitch.
    ///
    /// - Parameter multiple: The multiplier applied to the thread pitch. Defaults to 1.
    public static func pitch(multiple: Double = 1) -> Self {
        .init(size: .pitch(multiple: multiple))
    }

    /// A lead-in spanning the full thread depth at the specified cone angle.
    ///
    /// The radial depth equals the thread depth. The axial length is determined
    /// by the cone angle (e.g. 120° produces a steeper chamfer than 90°).
    /// A 90° cone angle is equivalent to a 45° chamfer, same as ``standard``.
    ///
    /// - Parameter angle: The included cone angle.
    public static func angle(_ angle: Angle) -> Self {
        .init(size: .angle(angle))
    }

    func resolved(for thread: ScrewThread) -> (depth: Double, length: Double) {
        switch size {
        case .constant(let depth, let length):
            return (depth, length)
        case .depth(let multiple):
            let d = thread.depth * multiple
            return (d, d)
        case .pitch(let multiple):
            let d = thread.pitch * multiple
            return (d, d)
        case .angle(let angle):
            let depth = thread.depth
            let length = depth * tan(90° - angle / 2)
            return (depth, length)
        }
    }

    func edgeProfile(for thread: ScrewThread) -> EdgeProfile {
        let (depth, length) = resolved(for: thread)
        return .chamfer(depth: depth, height: length)
    }

    enum Size: Sendable {
        case constant (depth: Double, length: Double)
        case depth (multiple: Double)
        case pitch (multiple: Double)
        case angle (Angle)
    }
}

internal extension Geometry3D {
    func applyingLeadIn(_ leadIn: LeadIn?, thread: ScrewThread, on side: DirectionalAxis<D3>, shape: any Geometry2D) -> any Geometry3D {
        if let leadIn {
            cuttingEdgeProfile(leadIn.edgeProfile(for: thread), on: side) { shape }
        } else {
            self
        }
    }
}
