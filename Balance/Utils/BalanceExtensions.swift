//
//  BalanceExtentions.swift
//  Balance
//
//  Created by Gonzalo Perisset on 10/04/2023.
//

import SwiftUI

extension Color {
    static var random: Color {
        let colorRND = Color(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1))
        return colorRND
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
        guard let windowScene = connectedScenes.first(where: { $0.windows.contains(where: { $0.isKeyWindow }) }) else {
            return nil
        }
        return windowScene.windows.first(where: { $0.isKeyWindow })
    }
}

extension Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else {
            return nil
        }
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        self = Image(uiImage: uiImage)
    }
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        if let rootViewController = UIApplication.shared.currentUIWindow()?.rootViewController {
            rootViewController.view.addSubview(controller.view)
        }
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIImage {
    func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self
        UIGraphicsBeginImageContext(size)
        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)
        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        if let mergedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return mergedImage
        }
        return UIImage()
    }
}

extension UIImage {
    func aspectFittedToHeight(_ newHeight: CGFloat) -> UIImage {
        let scale = newHeight / self.size.height
        let newWidth = self.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        let renderer = UIGraphicsImageRenderer(size: newSize)

        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

extension View {
    func adaptsToKeyboard() -> some View {
        let modifier = modifier(AdaptsToKeyboard())
        return modifier
    }
}

extension UIDevice {
    var hasNotch: Bool {
        if let bottom = UIApplication.shared.mainKeyWindow?.safeAreaInsets.bottom {
            return bottom > 0
        }
        return false
    }
}

extension UIApplication {
    var mainKeyWindow: UIWindow? {
        let aux = connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
        return aux
    }
}

extension Notification.Name {
    static let goBackground = Notification.Name("goBackground")
    static let coinsUpdate = Notification.Name("coinsUpdate")
    static let coinsRefresh = Notification.Name("coinsRefresh")
    static let coinsAlert = Notification.Name("coinsAlert")
    static let heartAlert = Notification.Name("heartAlert")
}

// swiftlint:disable operator_whitespace
// swiftlint:disable large_tuple
extension Date {
    static func -(recent: Date, previous: Date) -> (hour: Int?, minute: Int?, second: Int?) {
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (hour: hour, minute: minute, second: second)
    }
}

extension DateFormatter {
    static var sharedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
}

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

extension Array {
    func first(elementCount: Int) -> Array {
          let min = Swift.min(elementCount, count)
          return Array(self[0..<min])
    }
}
