import UIKit

public extension UIView {
    var leftConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .left)
    }

    var rightConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .right)
    }

    var topConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .top)
    }

    var bottomConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .bottom)
    }

    var heightConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .height)
    }

    var widthConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .width)
    }

    var trailingConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .trailing)
    }

    var leadingConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .leading)
    }

    var centerXConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .centerX)
    }

    var centerYConstraint: NSLayoutConstraint? {
        return constraintForView(self, attribute: .centerY)
    }
}

func constraintForView(_ v: UIView, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {

    func lookForConstraint(in view: UIView?) -> NSLayoutConstraint? {
        guard let constraints = view?.constraints else {
            return nil
        }
        for c in constraints {
            if let fi = c.firstItem as? NSObject, fi == v && c.firstAttribute == attribute {
                return c
            } else if let si = c.secondItem as? NSObject, si == v && c.secondAttribute == attribute {
                return c
            }
        }
        return nil
    }

    return lookForConstraint(in: v.superview) ?? lookForConstraint(in: v)
}
