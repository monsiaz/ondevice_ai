import UIKit
import Social

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleSharedContent()
    }
    
    private func handleSharedContent() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            close()
            return
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier("public.plain-text") {
            itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { [weak self] (item, error) in
                guard let self = self else { return }
                
                if let text = item as? String {
                    self.openMainApp(with: text)
                } else if let url = item as? URL, let text = try? String(contentsOf: url) {
                    self.openMainApp(with: text)
                } else {
                    self.close()
                }
            }
        } else if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] (item, error) in
                guard let self = self else { return }
                
                if let url = item as? URL {
                    self.openMainApp(with: "Analyze this: \(url.absoluteString)")
                } else {
                    self.close()
                }
            }
        } else {
            close()
        }
    }
    
    private func openMainApp(with text: String) {
        // URL scheme to open main app with shared text
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "ondeviceai://analyze?text=\(encodedText)"
        
        if let url = URL(string: urlString) {
            var responder: UIResponder? = self as UIResponder
            let selector = #selector(openURL(_:))
            
            while responder != nil {
                if responder!.responds(to: selector) && responder != self {
                    responder!.perform(selector, with: url, afterDelay: 0)
                    break
                }
                responder = responder?.next
            }
        }
        
        close()
    }
    
    @objc private func openURL(_ url: URL) {
        // This will be handled by the system
    }
    
    private func close() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
}
