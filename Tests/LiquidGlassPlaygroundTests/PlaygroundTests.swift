import Testing
@testable import LiquidGlassPlayground

@Suite("LiquidGlass Playground Tests")
struct PlaygroundTests {
    @Test("Default configuration has expected values")
    func defaultConfiguration() {
        let config = GlassConfiguration()
        #expect(config.blurRadius == 20)
        #expect(config.refractionIndex == 0.5)
        #expect(config.tintOpacity == 0.15)
        #expect(config.cornerRadius == 16)
        #expect(config.saturation == 1.2)
        #expect(config.brightness == 0.05)
        #expect(config.shadowRadius == 8)
        #expect(config.borderWidth == 0.5)
        #expect(config.borderOpacity == 0.3)
    }

    @Test("Preset library contains 20 presets")
    func presetCount() {
        #expect(PresetLibrary.shared.presets.count == 20)
    }

    @Test("Preset lookup by name works")
    func presetLookup() {
        let frosted = PresetLibrary.shared.preset(named: "Frosted")
        #expect(frosted != nil)
        #expect(frosted?.name == "Frosted")

        let missing = PresetLibrary.shared.preset(named: "NonExistent")
        #expect(missing == nil)
    }

    @Test("Preset lookup is case-insensitive")
    func presetCaseInsensitive() {
        let result = PresetLibrary.shared.preset(named: "neon")
        #expect(result != nil)
        #expect(result?.name == "Neon")
    }

    @Test("Code exporter produces valid output")
    func codeExport() {
        let exporter = CodeExporter()
        let config = GlassConfiguration()
        let code = exporter.export(config)

        #expect(code.contains("RoundedRectangle"))
        #expect(code.contains(".ultraThinMaterial"))
        #expect(code.contains(".saturation"))
        #expect(code.contains(".brightness"))
    }

    @Test("Code exporter full view output")
    func codeExportView() {
        let exporter = CodeExporter()
        let code = exporter.exportView(GlassConfiguration(), viewName: "TestCard")

        #expect(code.contains("struct TestCard: View"))
        #expect(code.contains("import SwiftUI"))
    }

    @Test("Parameter controls are defined")
    func parameterControls() {
        let controls = ParameterControl.allControls
        #expect(controls.count == 9)
        #expect(controls.first?.id == "blurRadius")
    }

    @Test("Tutorial has all steps")
    func tutorialSteps() {
        #expect(BasicGlassTutorial.totalSteps == 7)
        #expect(BasicGlassTutorial.steps.first?.title == "The Basics")
        #expect(BasicGlassTutorial.steps.last?.title == "Putting It Together")
    }

    @Test("CodableColor roundtrip")
    func codableColor() {
        let color = CodableColor(red: 0.5, green: 0.3, blue: 0.8, opacity: 0.9)
        #expect(color.red == 0.5)
        #expect(color.green == 0.3)
        #expect(color.blue == 0.8)
        #expect(color.opacity == 0.9)
    }
}
