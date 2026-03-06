import Testing
import Helical

private func isClose(_ a: Double, _ b: Double) -> Bool { abs(a - b) < 1e-9 }

struct ISOMetricThreadTests {
    // The minor diameter is derived from major and pitch via the V-thread formula,
    // not stored directly — worth verifying the formula constant is correct.
    @Test func `minor diameter is major - pitch × 1.082532`() {
        #expect(isClose(ScrewThread.m3.minorDiameter,  3.0  - 0.5  * 1.082532))
        #expect(isClose(ScrewThread.m8.minorDiameter,  8.0  - 1.25 * 1.082532))
        #expect(isClose(ScrewThread.m64.minorDiameter, 64.0 - 6.0  * 1.082532))
    }
}
