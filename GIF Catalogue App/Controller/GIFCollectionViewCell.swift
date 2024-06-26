//
//  GIFCollectionViewCell.swift
//  GIF Catalogue App
//
//  Created by liga.griezne on 28/03/2024.
//

import UIKit
import RxSwift
import SDWebImage
import ImageIO

class GIFCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    private let placeholderURL = URL(string: "https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExaTJjN2N2YnBhMzQzN2VvZGR6aWFnaDl5eWJiemJidGF0aW5zczRtaiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/3oEjI6SIIHBdRxXI40/giphy.gif")
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    func configure(with gifURL: String) {
        imageView.sd_setImage(with: placeholderURL, completed: nil)
        _ = imageView.loadGIF(from: gifURL)
            .subscribe(onNext: { _ in
            }, onError: { error in
            })
    }
}

extension UIImageView {
    func loadGIF(from url: String) -> Observable<Void> {
        return Observable.create { observer in
            DispatchQueue.global().async {
                guard let gifURL = URL(string: url) else {
                    observer.onError(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                    return
                }
                do {
                    let data = try Data(contentsOf: gifURL)
                    guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                        observer.onError(NSError(domain: "Invalid GIF data", code: 0, userInfo: nil))
                        return
                    }
                    let frameCount = CGImageSourceGetCount(source)
                    var images = [UIImage]()
                    for i in 0..<frameCount {
                        guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else {
                            continue
                        }
                        let uiImage = UIImage(cgImage: cgImage)
                        images.append(uiImage)
                    }
                    DispatchQueue.main.async {
                        self.animationImages = images
                        self.animationDuration = Double(frameCount) * 0.1 // Adjust duration as needed
                        self.startAnimating()
                        observer.onNext(())
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
