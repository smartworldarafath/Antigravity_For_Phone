//
//  NativeSplashView.swift
//  Antigravity for iOS / iPadOS
//

import UIKit

/// Lightweight native splash overlay featuring a smooth pulsing Antigravity icon
/// and a buttery smooth 300ms spring exit transition.
public final class NativeSplashView: UIView {

    private let logoImageView = UIImageView()
    private var isDark: Bool = true

    public init(isDark: Bool = true) {
        self.isDark = isDark
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = isDark ? UIColor(red: 0.043, green: 0.055, blue: 0.09, alpha: 1.0) : .white

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        if let image = UIImage(named: "SplashLogo") {
            logoImageView.image = image
        } else {
            // Fallback system symbol if asset is absent
            if #available(iOS 13.0, *) {
                logoImageView.image = UIImage(systemName: "sparkles")
                logoImageView.tintColor = isDark ? UIColor(white: 0.65, alpha: 1.0) : UIColor(white: 0.4, alpha: 1.0)
            }
        }

        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 64),
            logoImageView.heightAnchor.constraint(equalToConstant: 64)
        ])

        startPulseAnimation()
    }

    public func setDarkTheme(_ dark: Bool) {
        self.isDark = dark
        backgroundColor = dark ? UIColor(red: 0.043, green: 0.055, blue: 0.09, alpha: 1.0) : .white
    }

    private func startPulseAnimation() {
        UIView.animate(
            withDuration: 1.2,
            delay: 0,
            options: [.autoreverse, .repeat, .curveEaseInOut],
            animations: {
                self.logoImageView.alpha = 0.35
                self.logoImageView.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
            },
            completion: nil
        )
    }

    /// Dismisses the splash overlay with an ultra-smooth 320ms spring dissolve
    public func dismiss(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.32,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0.5,
            options: [.curveEaseOut],
            animations: {
                self.alpha = 0.0
                self.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
            },
            completion: { _ in
                self.removeFromSuperview()
                completion?()
            }
        )
    }
}
