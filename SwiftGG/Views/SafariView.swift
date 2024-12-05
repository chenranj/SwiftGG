import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = false
        configuration.barCollapsingEnabled = true
        
        let safariViewController = SFSafariViewController(url: url, configuration: configuration)
        safariViewController.preferredControlTintColor = .tintColor
        safariViewController.dismissButtonStyle = .close
        safariViewController.delegate = context.coordinator
        
        safariViewController.preferredBarTintColor = .systemBackground
        safariViewController.preferredControlTintColor = .tintColor
        safariViewController.modalPresentationStyle = .automatic
        
        safariViewController.dismissButtonStyle = .cancel
        
        return safariViewController
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func updateUIViewController(_ safariViewController: SFSafariViewController, context: Context) {
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let parent: SafariView
        
        init(parent: SafariView) {
            self.parent = parent
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            parent.dismiss()
        }
        
        func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
            return []
        }
        
        func safariViewController(_ controller: SFSafariViewController, excludedActivityTypesFor URL: URL, title: String?) -> [UIActivity.ActivityType] {
            return [.addToReadingList, .assignToContact, .copyToPasteboard, 
                   .mail, .message, .postToFacebook, .postToTwitter, 
                   .print, .saveToCameraRoll, .markupAsPDF]
        }
    }
} 