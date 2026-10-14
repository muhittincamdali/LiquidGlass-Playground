<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-tr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-tr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/LiquidGlassKit/main/.github/brand/banner-tr-light.svg" alt="LiquidGlassKit: SwiftUI için Liquid Glass yüzeyleri ve kontrolleri."></picture></p>

<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a></p>

# LiquidGlass-Playground taşındı

**Bu proje artık [LiquidGlassKit](https://github.com/muhittincamdali/LiquidGlassKit) içinde yaşıyor.**
Bu depo arşivlendi ve bir daha değişmeyecek. Burada yayımlanan son sürüm
[v1.0.0](https://github.com/muhittincamdali/LiquidGlass-Playground/releases/tag/v1.0.0).

## Kod nereye gitti

LiquidGlassKit 2.1.0, bu depodaki işe yarar parçaları `glassSurface` üzerine yeniden yazarak ve
testlerle kapsayarak birleştirdi:

| Burada                    | LiquidGlassKit içinde                                                                                                                                                                                                     |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CodeExporter`            | [`GlassCodeExporter`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Core/GlassCodeExporter.swift): ayarlanmış bir temayı ya da tam bir görünümü paketi kullanan Swift koduna çevirir |
| Parametre ayarlama ekranı | Demo uygulamasındaki [Playground ekranı](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Examples/LiquidGlassDemo/Sources/PlaygroundScreen.swift): sliderlar, canlı önizleme ve dışa aktarılan kod            |
| Adlandırılmış görünümler  | [`GlassPreset`](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/Core/GlassPreset.swift): 14 hazır tema                                                                                 |

Anlatım için DocC makalesi:
[Tuning and Exporting a Look](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/Sources/LiquidGlassKit/LiquidGlassKit.docc/TuningAndExportingALook.md)
(İngilizce). Buradaki her dosya pakete taşınmadı; kapsamın ayrıntısı için
[2.1.0 değişiklik günlüğüne](https://github.com/muhittincamdali/LiquidGlassKit/blob/main/CHANGELOG.md)
bakın.

## Yeni paketi kurun

```swift
.package(url: "https://github.com/muhittincamdali/LiquidGlassKit.git", from: "2.1.0")
```

Ardından hedefinize `.product(name: "LiquidGlassKit", package: "LiquidGlassKit")` ekleyin.
iOS 17, macOS 14, tvOS 17, watchOS 10 ya da visionOS 1 ve Swift 6.0 gerekir. Tam dokümantasyon:
[LiquidGlassKit README](https://github.com/muhittincamdali/LiquidGlassKit#readme).

## Lisans

MIT, bkz. [LICENSE](LICENSE).
