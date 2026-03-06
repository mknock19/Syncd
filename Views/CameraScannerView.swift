import SwiftUI
import VisionKit

// MARK: - Camera Scanner Sheet
// Full screen camera overlay for scanning barcodes or ingredient text

struct CameraScannerSheet: View {
    let scanMode: ScanView.ScanMode
    let onScanComplete: (String) -> Void
    let onCancel: () -> Void
    
    @State private var scannedItems: [String] = []
    
    var body: some View {
        ZStack {
            // Camera View
            if DataScannerViewController.isSupported && DataScannerViewController.isAvailable {
                DataScannerRepresentable(
                    scanMode: scanMode,
                    onItemScanned: { text in
                        onScanComplete(text)
                    }
                )
                .ignoresSafeArea()
            } else {
                // Fallback for devices without scanner support
                cameraUnavailableView
            }
            
            // Overlay UI
            VStack {
                // Top Bar with Cancel
                HStack {
                    Button(action: onCancel) {
                        HStack(spacing: 6) {
                            Image(systemName: "xmark")
                            Text("Cancel")
                        }
                        .font(SyncdTheme.Typography.headline())
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(.ultraThinMaterial)
                        .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
                    }
                    
                    Spacer()
                    
                    // Mode indicator
                    HStack(spacing: 6) {
                        Image(systemName: scanMode.icon)
                        Text(scanMode.rawValue)
                    }
                    .font(SyncdTheme.Typography.subheadline())
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                Spacer()
                
                // Instructions
                VStack(spacing: 8) {
                    Text(scanMode == .barcode ? "Point at a barcode" : "Point at ingredient list")
                        .font(SyncdTheme.Typography.headline())
                        .foregroundColor(.white)
                    
                    Text("Tap on highlighted text to scan")
                        .font(SyncdTheme.Typography.subheadline())
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(.ultraThinMaterial)
                .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
                .padding(.bottom, 100)
            }
        }
        .background(Color.black)
    }
    
    private var cameraUnavailableView: some View {
        VStack(spacing: 20) {
            Image(systemName: "camera.fill")
                .font(.system(size: 60))
                .foregroundColor(SyncdTheme.Colors.textMuted)
            
            Text("Camera Unavailable")
                .font(SyncdTheme.Typography.title2())
                .foregroundColor(.white)
            
            Text("This device doesn't support live text scanning.\nPlease try on a device with iOS 16+ and A12 chip or newer.")
                .font(SyncdTheme.Typography.body())
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button("Close") {
                onCancel()
            }
            .font(SyncdTheme.Typography.headline())
            .foregroundColor(SyncdTheme.Colors.hotPink)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
            .cornerRadius(SyncdTheme.Styles.cornerRadiusMedium)
        }
    }
}

// MARK: - DataScanner Representable
struct DataScannerRepresentable: UIViewControllerRepresentable {
    let scanMode: ScanView.ScanMode
    let onItemScanned: (String) -> Void
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let recognizedDataTypes: Set<DataScannerViewController.RecognizedDataType>
        
        if scanMode == .barcode {
            recognizedDataTypes = [.barcode()]
        } else {
            recognizedDataTypes = [.text()]
        }
        
        let scanner = DataScannerViewController(
            recognizedDataTypes: recognizedDataTypes,
            qualityLevel: .balanced,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let parent: DataScannerRepresentable
        
        init(_ parent: DataScannerRepresentable) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                parent.onItemScanned(text.transcript)
            case .barcode(let barcode):
                if let payload = barcode.payloadStringValue {
                    parent.onItemScanned(payload)
                }
            @unknown default:
                break
            }
        }
    }
}

// MARK: - Legacy Camera Scanner View (kept for compatibility)
struct CameraScannerView: UIViewControllerRepresentable {
    @Binding var scannedText: String?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let scanner = DataScannerViewController(
            recognizedDataTypes: [.text()],
            qualityLevel: .balanced,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: false,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        scanner.delegate = context.coordinator
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let parent: CameraScannerView
        
        init(_ parent: CameraScannerView) {
            self.parent = parent
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                parent.scannedText = text.transcript
                parent.presentationMode.wrappedValue.dismiss()
            default:
                break
            }
        }
    }
}

// MARK: - Scanner Availability Check
extension CameraScannerView {
    static var isSupported: Bool {
        DataScannerViewController.isSupported && DataScannerViewController.isAvailable
    }
}
