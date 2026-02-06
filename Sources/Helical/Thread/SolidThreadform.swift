import Foundation
import Cadova

internal struct SolidThreadform: Threadform {
    var body: any Geometry2D {
        @Environment(\.thread!) var thread
        Rectangle(x: thread.depth + innerInset, y: thread.pitch)
            .translated(x: -innerInset)
    }

    func pitchDiameter(for thread: ScrewThread) -> Double {
        thread.majorDiameter
    }
}
