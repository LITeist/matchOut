//
//  BadgeButton.swift
//  BadgeButton
//
//  Created by Glenn Posadas on 3/16/22.
//

import UIKit

/**
 A subclass of `UIButton` that has a badge view ready.
 
 Use the convenience init, like so:
 
 ```
 let b = BadgeButton(icon: UIImage(named: "bell")!)
 let b = BadgeButton(icon: UIImage(named: "bell", shouldLimitValueTo9: true)!)
 ```
 
 */
@objc
class BadgeButton: UIButton {
  
  // MARK: - Properties
  
  let defaultRedBadgeBG = UIColor(red: 217/255.0, green: 112/255.0, blue: 60/255.0, alpha: 1)
  let defaultCornerRadius: CGFloat = 12
  let defaultFontSize: CGFloat = 15
  let defaultBadgeSize = CGSize(width: 24, height: 24)
  
  /// Set this to true through the constructor  if you want to limit the value to 9+ if value is >= 10.
  private(set) var shouldLimitValueTo9: Bool = false
  /// Reference to prevent blinking animation
  private(set) var currentBadgeCount: Int = 0
  
  private lazy var badgeBGView: UIView = {
    let v = UIView()
    v.backgroundColor = defaultRedBadgeBG
    v.layer.cornerRadius = defaultCornerRadius
    v.translatesAutoresizingMaskIntoConstraints = false
    v.alpha = 0
    v.addSubview(badgeCountLabel)
    NSLayoutConstraint.activate([
      badgeCountLabel.topAnchor.constraint(equalTo: v.topAnchor),
      badgeCountLabel.bottomAnchor.constraint(equalTo: v.bottomAnchor),
      badgeCountLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 12),
      badgeCountLabel.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -12)
    ])
    return v
  }()
  
  private lazy var badgeCountLabel: UILabel = {
    let l = UILabel()
    l.textColor = .white
    l.textAlignment = .center
    l.font = .systemFont(ofSize: defaultFontSize)
    l.layer.cornerRadius = defaultCornerRadius
    l.translatesAutoresizingMaskIntoConstraints = false
    return l
  }()
  
  var icon: UIImage!
  
  // MARK: - Functions
  // MARK: Overrides
  
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  @objc
  convenience init(icon: UIImage) {
    self.init(frame: .zero)
    
    self.icon = icon
    layout()
  }
  
  @objc
  convenience init(icon: UIImage, shouldLimitValueTo9: Bool) {
    self.init(icon: icon)
    self.shouldLimitValueTo9 = shouldLimitValueTo9
  }
  
  private func layout() {
    setImage(
      icon,
      for: .normal
    )
    
    addSubview(badgeBGView)
    NSLayoutConstraint.activate([
      badgeBGView.heightAnchor.constraint(equalToConstant: defaultBadgeSize.height),
      badgeBGView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
      badgeBGView.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public

@objc
extension BadgeButton {
  /// Takes a new value in integer form.
  func setBadgeValue(_ value: Int) {
    guard currentBadgeCount != value else {
      return
    }
    
    currentBadgeCount = value
    
    DispatchQueue.main.async {
      if self.badgeBGView.alpha == 0 {
        UIView.animate(withDuration: 0.3) {
          self.badgeBGView.alpha = 1
        }
      }
      
      guard value > 0 else {
        self.removeBadge()
        return
      }
     
      UIView.transition(with: self.badgeCountLabel,
                        duration: 0.3,
                        options: .transitionFlipFromBottom,
                        animations: {
        let text: String = self.shouldLimitValueTo9 ? value >= 10 ? "9+" : "\(value)" : "\(value)"
        self.badgeCountLabel.text = text
      }, completion: nil)
    }
  }
  
  /// Remove the badge.
  func removeBadge() {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.3,
                     delay: 0,
                     options: .curveEaseOut) {
        self.badgeBGView.alpha = 0
        self.badgeCountLabel.text = ""
      }
    }
  }
}
