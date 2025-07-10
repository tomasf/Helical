# Helical

Helical is a library for [Cadova](https://github.com/tomasf/Cadova) that simplifies the creation of threaded components and related parts. It supports widely-used metric threads, bolts, and nuts, as well as the ability to customize these components to fit specific requirements.

[Bolts demo](Sources/Demo/bolts.stl)<br/>
[Nuts and washers demo](Sources/Demo/nutsAndWashers.stl)

## Installation

Integrate Helical into your project with the Swift Package Manager by adding it as a dependency in your `Package.swift` file:

```swift
.package(url: "https://github.com/tomasf/Helical.git", from: "0.2.0")
```

Then, import Helical where it's needed:
```swift
import Helical
```

## Usage
<img align="right" width="100" src="https://github.com/user-attachments/assets/6481b084-dc59-4c2d-b5a8-e32a44beb6e8" />

### Standard Components

Helical simplifies the process of creating threaded shapes, making it easier to incorporate threaded holes into your models. It also provides a selection of standard bolts, nuts, and corresponding holes. Creating a typical M8x30 hex head bolt is simple:

```swift
Bolt.hexHead(.m8, length: 20, shankLength: 5)
```

This generates a standard [DIN 931](https://www.fasteners.eu/standards/DIN/931/) bolt, as expected.

<img align="right" width="100" src="https://github.com/user-attachments/assets/728e1d80-d713-4b2f-abdf-99b5e87e20f5" />

### Customizing Components
Beyond the standard offerings, Helical allows for modifications to fit unique requirements:


```swift
Bolt.hexHead(.isoMetric(.m8, pitch: 0.75), headWidth: 15, headHeight: 6.5, length: 20)
```

Or fully customize parts to your specific needs:

<img align="right" width="100" src="https://github.com/user-attachments/assets/33a11406-b781-401a-8884-58fce44a6b8b" />

```swift
let thread = ScrewThread(
    handedness: .left,
    starts: 2,
    pitch: 1.5,
    majorDiameter: 6.2,
    minorDiameter: 5.3,
    form: .trapezoidal(angle: 90°, crestWidth: 0.25)
)
let customBolt = Bolt(
    thread: thread,
    length: 15,
    shankLength: 3,
    shankDiameter: 5,
    headShape: .countersunk(angle: 80°, topDiameter: 10, boltDiameter: 5),
    socket: .slotted(length: 10, width: 1, depth: 1.4)
)
```

### Holes

<img align="right" width="200" src="https://github.com/user-attachments/assets/e9c6fe05-5f06-43ec-a7a8-4d17435db0a4" />

Creating a matching countersunk clearance hole for a bolt is straightforward:

```swift
Box(13)
    .aligned(at: .centerXY)
    .subtracting {
        customBolt.clearanceHole(recessedHead: true)
    }
```

As is making a threaded hole for a particular thread:

<img align="right" width="200" src="https://github.com/user-attachments/assets/bcaf3285-61f4-4ebe-b297-21aa063a2e2d" />

```swift
Box(13)
    .aligned(at: .centerXY)
    .subtracting {
        ThreadedHole(thread: thread, depth: 13)
    }
```

## Contributing

We welcome contributions. Feel free to open issues for feedback or suggestions and submit pull requests for improvements to the codebase.

