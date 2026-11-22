//
//  DocumentPickerManager.swift
//  Antigravity for iOS / iPadOS
//

import UIKit
import UniformTypeIdentifiers

/// Manages document and folder picking for iOS and iPadOS with persistent security-scoped access.
public final class DocumentPickerManager: NSObject, UIDocumentPickerDelegate {

    public static let shared = DocumentPickerManager()

    private var onFolderPicked: ((String?) -> Void)?
    private var onFilesPicked: (([URL]) -> Void)?

    private override init() {
        super.init()
    }

    /// Presents folder picker (e.g. for workspace selection)
    public func pickFolder(from viewController: UIViewController, completion: @escaping (String?) -> Void) {
        self.onFolderPicked = completion
        let picker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder], asCopy: false)
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.folder"], in: .open)
        }
        picker.delegate = self
        picker.allowsMultipleSelection = false
        viewController.present(picker, animated: true)
    }

    /// Presents file picker (for attaching files, images, code to chat)
    public func pickFiles(from viewController: UIViewController, allowsMultiple: Bool, completion: @escaping ([URL]) -> Void) {
        self.onFilesPicked = completion
        let picker: UIDocumentPickerViewController
        if #available(iOS 14.0, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item], asCopy: true)
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        }
        picker.delegate = self
        picker.allowsMultipleSelection = allowsMultiple
        viewController.present(picker, animated: true)
    }

    // MARK: - UIDocumentPickerDelegate

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            onFolderPicked?(nil)
            onFilesPicked?([])
            return
        }

        if url.hasDirectoryPath {
            // Start accessing security-scoped resource
            let didStartAccess = url.startAccessingSecurityScopedResource()
            defer {
                if didStartAccess {
                    // Bookmark can be saved for persistent session access
                }
            }
            onFolderPicked?(url.path)
            onFolderPicked = nil
        } else {
            onFilesPicked?(urls)
            onFilesPicked = nil
        }
    }

    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        onFolderPicked?(nil)
        onFilesPicked?([])
        onFolderPicked = nil
        onFilesPicked = nil
    }
}
