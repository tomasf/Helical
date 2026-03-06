import Testing
import Helical
import Cadova

private func isClose(_ a: Double, _ b: Double, tolerance: Double = 1e-9) -> Bool { abs(a - b) < tolerance }

struct TrapezoidalThreadformTests {
    @Test func `angle is sum of both flank angles`() {
        let symmetric = TrapezoidalThreadform(angle: 60°, crestWidth: 0.0625)
        #expect(symmetric.angle == 60°)

        let asymmetric = TrapezoidalThreadform(leadingFlankAngle: 7°, trailingFlankAngle: 45°, crestWidth: 0.1)
        #expect(asymmetric.angle == 52°)
    }

    @Test func `pitch diameter formula`() {
        // M3: major=3.0 + 2*(crestWidth - pitch/2)/(2*tan30°) ≈ 2.6752
        let formM3 = TrapezoidalThreadform(angle: 60°, crestWidth: ScrewThread.m3.pitch / 8)
        #expect(isClose(formM3.pitchDiameter(for: .m3), 2.6752, tolerance: 1e-4))

        // M8: same formula ≈ 7.1881
        let formM8 = TrapezoidalThreadform(angle: 60°, crestWidth: ScrewThread.m8.pitch / 8)
        #expect(isClose(formM8.pitchDiameter(for: .m8), 7.1881, tolerance: 1e-4))
    }

    @Test func `minimum pitch formula`() {
        // M3: crestWidth + depth*(tan30°+tan30°) = 0.0625 + 0.270633*2/√3 ≈ 0.375
        let form = TrapezoidalThreadform(angle: 60°, crestWidth: ScrewThread.m3.pitch / 8)
        #expect(isClose(form.minimumPitch(for: .m3), 0.375, tolerance: 1e-6))
    }
}

struct KnuckleThreadformTests {
    @Test func `minimum pitch is 2 × crest radius`() {
        // E27: h=1.25, pitch=3.62 → radius=(1.5625+3.2761)/5 ≈ 0.96772
        // minimumPitch = 2*radius ≈ 1.93544
        let e27 = ScrewThread.e27
        let h = (e27.majorDiameter - e27.minorDiameter) / 2
        let r = (h * h + e27.pitch * e27.pitch / 4) / (4 * h)
        let form: KnuckleThreadform = .knuckle(crestRadius: r, rootRadius: r)
        #expect(isClose(form.minimumPitch(for: e27), 2 * r))
        #expect(isClose(form.minimumPitch(for: e27), 1.93544, tolerance: 1e-4))
    }

    @Test func `pitch diameter formula`() {
        #expect(isClose(ScrewThread.e27.pitchDiameter, 25.75, tolerance: 1e-3))
    }
}
