import Foundation
import Cadova

/// A protocol defining the geometry at the tip of a bolt.
public protocol BoltPoint: Shape3D {
    /// Portion of the nominal bolt length consumed by the point geometry.
    var consumedLength: Double { get }
    /// Geometry to subtract from the bolt body to form the point.
    @GeometryBuilder3D var negativeBody: any Geometry3D { get }
}

public extension BoltPoint {
    /// Defaults to empty geometry.
    @GeometryBuilder3D var body: any Geometry3D {}
    /// Defaults to empty geometry.
    @GeometryBuilder3D var negativeBody: any Geometry3D { }
}
