import Foundation
import Cadova

// A bolt head shape for bolts without a head, such as set screws

public struct ProfiledBoltHeadShape: BoltHeadShape {
    let edgeProfile: EdgeProfile

    public init(edgeProfile: EdgeProfile) {
        self.edgeProfile = edgeProfile
    }

    public var negativeBody: any Geometry3D {
        @Environment(\.thread!) var thread
        @Environment(\.tolerance) var tolerance

        edgeProfile.profile
            .translated(x: (thread.majorDiameter - tolerance) / 2)
            .revolved()
    }

    public let height = 0.0
    public var body: any Geometry3D {}
    public var recess: any Geometry3D {}
}
