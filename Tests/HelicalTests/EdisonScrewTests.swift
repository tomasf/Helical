import Testing
import Helical

private func isClose(_ a: Double, _ b: Double, tolerance: Double = 1e-9) -> Bool { abs(a - b) < tolerance }

struct EdisonScrewTests {
    // pitchDiameter is computed via the knuckle threadform arc formula —
    // several steps of non-trivial math over stored major/minor/pitch values.
    @Test func `pitch diameter is computed correctly from arc formula`() {
        // E27: h=1.25, pitch=3.62, radius≈0.96772 → pitchDiameter≈25.75
        #expect(isClose(ScrewThread.e27.pitchDiameter, 25.75, tolerance: 1e-3))

        // E5.5: radius=17/60, d=9/60=0.15 → pitchDiameter = 5.5 - 0.3 = 5.2 (exact)
        #expect(isClose(ScrewThread.e5p5.pitchDiameter, 5.2, tolerance: 1e-6))
    }
}
