//
//  ImageCache.swift
//  iOS-Mongsil
//
//  Created by Groot on 2023/01/06.
//

import Foundation
import UIKit.UIImage
import Combine

protocol ImageCacheProtocol: AnyObject {
    func image(for url: URL) -> UIImage?
    func insertImage(_ image: UIImage?, for url: URL)
    func removeImage(for url: URL)
    func removeAllImages()
    subscript(_ url: URL) -> UIImage? { get set }
}

final class ImageCache: ImageCacheProtocol {
    private let lock = NSLock()
    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
        let cache = NSCache<AnyObject, AnyObject>()

        return cache
    }()
    
    func image(for url: URL) -> UIImage? {
        lock.lock()
        defer { lock.unlock() }
        
        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
            return image
        }
        
        return nil
    }

    func insertImage(_ image: UIImage?, for url: URL) {
        guard let image = image else { return removeImage(for: url) }

        lock.lock()
        defer { lock.unlock() }
        imageCache.setObject(image, forKey: url as AnyObject)
    }

    func removeImage(for url: URL) {
        lock.lock()
        defer { lock.unlock() }
        imageCache.removeObject(forKey: url as AnyObject)
    }

    func removeAllImages() {
        lock.lock()
        defer { lock.unlock() }
        imageCache.removeAllObjects()
    }

    subscript(_ key: URL) -> UIImage? {
        get {
            return image(for: key)
        } set {
            return insertImage(newValue, for: key)
        }
    }
}
