import Foundation
import Cadova

/// A round/knuckle thread profile composed of circular arcs at the crest and root,
/// optionally connected by straight flank segments.
public struct KnuckleThreadform: Threadform {
    /// Radius of the circular arc at the crest.
    public let crestRadius: Double
    /// Radius of the circular arc at the root.
    public let rootRadius: Double

    public var body: any Geometry2D {
        @Environment(\.thread!) var thread
        let depth = thread.depth
        let pitch = thread.pitch

        // Arc centers in threadform coordinates (x = radial, y = axial)
        let crestCenter = Vector2D(x: depth - crestRadius, y: 0)
        let rootCenterTop = Vector2D(x: rootRadius, y: pitch / 2)
        let rootCenterBottom = Vector2D(x: rootRadius, y: -pitch / 2)

        // Vector from crest center to top root center
        let toTopRoot = rootCenterTop - crestCenter
        let centerDistance = toTopRoot.magnitude
        let radiusSum = crestRadius + rootRadius

        // Angle from crest center toward top root center
        let angleToTopRoot = atan2(toTopRoot)
        // By symmetry, angle toward bottom root center is the negation
        let angleToBottomRoot = -angleToTopRoot

        // Determine if arcs meet tangentially or need straight flanks
        let cosArg = min(1.0, radiusSum / centerDistance)
        let offsetAngle = Angle(radians: acos(cosArg))

        // Angles on the crest arc where flanks (or tangent points) meet
        let crestAngleTop = angleToTopRoot + offsetAngle
        let crestAngleBottom = angleToBottomRoot - offsetAngle

        let hasTangentArcs = centerDistance <= radiusSum + 1e-10

        // Root arc start/end at 180° (the point furthest from the crest, at x ≈ 0)
        let rootEdgeAngle: Angle = 180°

        // Start point: bottom root arc at 180°
        let startPoint = rootCenterBottom + Vector2D(
            x: rootRadius * cos(rootEdgeAngle),
            y: rootRadius * sin(rootEdgeAngle)
        )

        // Build path: bottom root → [flank] → crest → [flank] → top root → close
        var path = BezierPath2D(startPoint: startPoint)

        // Bottom root half-arc: sweep clockwise from 180° to the flank junction
        // The root arc angle corresponding to the crest angle is offset by 180°
        let rootAngleBottom = crestAngleBottom + 180°
        path = path.addingArc(center: rootCenterBottom, to: rootAngleBottom, clockwise: true)

        if !hasTangentArcs {
            // Straight flank from bottom root arc to crest arc
            let bottomCrestPoint = crestCenter + Vector2D(
                x: crestRadius * cos(crestAngleBottom),
                y: crestRadius * sin(crestAngleBottom)
            )
            path = path.addingLine(to: bottomCrestPoint)
        }

        // Crest arc: sweep counter-clockwise from bottom to top (through 0°, the crest)
        path = path.addingArc(center: crestCenter, to: crestAngleTop)

        if !hasTangentArcs {
            // Straight flank from crest arc to top root arc
            let rootAngleTop = crestAngleTop + 180°
            let topRootPoint = rootCenterTop + Vector2D(
                x: rootRadius * cos(rootAngleTop),
                y: rootRadius * sin(rootAngleTop)
            )
            path = path.addingLine(to: topRootPoint)
        }

        // Top root half-arc: sweep clockwise to 180°
        path = path.addingArc(center: rootCenterTop, to: rootEdgeAngle, clockwise: true)

        // Close along the inner edge
        path = path.addingLine(to: startPoint)

        return Polygon(path)
    }

    public func pitchDiameter(for thread: ScrewThread) -> Double {
        let pitch = thread.pitch
        let d = crestRadius - sqrt(crestRadius * crestRadius - pitch * pitch / 16)
        return thread.majorDiameter - 2 * d
    }
}

public extension Threadform where Self == KnuckleThreadform {
    /// Creates a knuckle (round) threadform with the specified arc radii.
    ///
    /// - Parameters:
    ///   - crestRadius: Radius of the circular arc at the crest.
    ///   - rootRadius: Radius of the circular arc at the root.
    /// - Returns: A knuckle threadform instance.
    ///
    static func knuckle(crestRadius: Double, rootRadius: Double) -> Self {
        KnuckleThreadform(crestRadius: crestRadius, rootRadius: rootRadius)
    }
}
