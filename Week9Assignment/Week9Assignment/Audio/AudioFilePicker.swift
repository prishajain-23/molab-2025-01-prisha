//
//  AudioFilePicker.swift
//  Week9Assignment
//
//  Created by Prisha Jain on 4/6/25.
//

// A SwiftUI-compatible wrapper for UIDocumentPickerViewController
// that allows users to select an audio file from the Files app.
// Once a file is selected, its URL is passed back via a callback.

import SwiftUI
import UniformTypeIdentifiers           // what is this? chat brought it in

struct AudioFilePicker: UIViewControllerRepresentable {
    /// Callback to handle the selected file URL
    var onFilePicked: (URL) -> Void

    /// Creates and configures the document picker controller
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        // Limit selection to audio file types only
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio])
        picker.delegate = context.coordinator
        return picker
    }

    /// No updates needed on the view controller
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    /// Creates the coordinator that bridges UIKit's delegate methods to SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(onFilePicked: onFilePicked)
    }

    /// Coordinator class acts as the UIDocumentPicker delegate
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        /// The callback to send selected file back to SwiftUI
        let onFilePicked: (URL) -> Void

        init(onFilePicked: @escaping (URL) -> Void) {
            self.onFilePicked = onFilePicked
        }

        /// Called when the user selects a document
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                onFilePicked(url)
            }
        }
    }
}
