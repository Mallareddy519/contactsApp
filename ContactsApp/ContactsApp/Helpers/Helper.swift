
import UIKit

extension UIImageView {
    private static var taskKey = 0
    private static var urlKey = 0
    
    private var currentTask: URLSessionTask? {
        get { return objc_getAssociatedObject(self, &UIImageView.taskKey) as? URLSessionTask }
        set { objc_setAssociatedObject(self, &UIImageView.taskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var currentURL: URL? {
        get { return objc_getAssociatedObject(self, &UIImageView.urlKey) as? URL }
        set { objc_setAssociatedObject(self, &UIImageView.urlKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func loadImageAsync(with urlString: String?) {
        weak var oldTask = currentTask
        currentTask = nil
        oldTask?.cancel()
        self.image = nil
        guard let urlString = urlString else { return }
        // check cache
        if let cachedImage = ImageCache.shared.image(forKey: urlString) {
            self.image = cachedImage
            return
        }
        // download
        let url = URL(string: urlString)!
        currentURL = url
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            self?.currentTask = nil
            //error handling
            if let error = error {
                if (error as NSError).domain == NSURLErrorDomain &&
                    (error as NSError).code == NSURLErrorCancelled { return }
                return
            }
            guard let data = data, let downloadedImage = UIImage(data: data) else { return }
            ImageCache.shared.save(image: downloadedImage, forKey: urlString)
            if url == self?.currentURL {
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }
        }
        currentTask = task
        task.resume()
    }
}

class ImageCache {
    private let cache = NSCache<NSString, UIImage>()
    private var observer: NSObjectProtocol!
    static let shared = ImageCache()
    
    private init() {
        // make sure to purge cache on memory pressure
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didReceiveMemoryWarningNotification,
                                                          object: nil, queue: nil) { [weak self] notification in
            self?.cache.removeAllObjects()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observer as Any)
    }
    
    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func save(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

enum DateFormat: String {
    case yyyy_MM_dd_T_HHmmssSSSZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case dd_MMM_yyyy_HHmmss = "dd MMM yyyy HH:mm:ss"
}

extension String {
    func dateFormat(fromFormat: DateFormat, toFormat: DateFormat) -> String {
        var formatedDateString: String = ""
        if !self.isEmpty {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = fromFormat.rawValue
            dateFormatter.locale = Locale(identifier: "en")
            guard let dateFormat = dateFormatter.date(from: self) else {
                return formatedDateString
            }
            dateFormatter.dateFormat = toFormat.rawValue
            formatedDateString = dateFormatter.string(from: dateFormat).uppercased()
        }
        return formatedDateString
    }
    
    func openUrl() {
        guard let url = URL(string: self) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
