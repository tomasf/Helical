import Foundation
import Cadova

/// A protocol defining the geometry and dimensions of a bolt head.
public protocol BoltHeadShape: Shape3D {
    /// Total height of the head.
    var height: Double { get }
    /// Portion of the nominal bolt length consumed by the head, such as the countersunk portion.
    var consumedLength: Double { get }
    /// Additional depth beyond the nominal bolt length needed to fully recess the head.
    var clearanceLength: Double { get }
    /// Shape to subtract when creating a recessed hole for this head.
    @GeometryBuilder3D var recess: any Geometry3D { get }
    /// Additional geometry to subtract from the bolt body.
    @GeometryBuilder3D var negativeBody: any Geometry3D { get }
}

public extension BoltHeadShape {
    /// Defaults to zero for heads that sit entirely above the mounting surface.
    var consumedLength: Double { 0 }
    /// Defaults to the full head height, for heads that sit entirely above the nominal length.
    var clearanceLength: Double { height }
    /// Defaults to empty geometry.
    var negativeBody: any Geometry3D { Box(.zero) }
}
