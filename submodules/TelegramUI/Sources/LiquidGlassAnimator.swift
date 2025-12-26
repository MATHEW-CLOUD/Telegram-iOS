
import UIKit
import AsyncDisplayKit

enum LiquidGlassAnimator {
    static func press(_ node: ASDisplayNode) {
        let t = CATransform3DMakeScale(0.93, 0.93, 1.0)
        animate(node: node, to: t, duration: 0.08, timing: .easeIn)
    }

    static func release(_ node: ASDisplayNode) {
        // “bounce” back via two quick springs
        animate(node: node, to: CATransform3DIdentity, duration: 0.18, timing: .spring(damping: 0.8, velocity: 0.0))
    }

    static func stretchY(_ node: ASDisplayNode) {
        let t = CATransform3DMakeScale(1.0, 1.07, 1.0)
        animate(node: node, to: t, duration: 0.10, timing: .easeIn)
    }

    private static func animate(node: ASDisplayNode, to transform: CATransform3D, duration: CFTimeInterval, timing: Timing) {
        let anim = CABasicAnimation(keyPath: "transform")
        anim.fromValue = node.layer.presentation()?.transform ?? node.layer.transform
        anim.toValue = transform
        anim.duration = duration
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false

        switch timing {
        case .easeIn:
            anim.timingFunction = CAMediaTimingFunction(name: .easeIn)
        case let .spring(damping, velocity):
            anim.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, Float(damping), 0.2, Float(1.0 + velocity))
        }

        node.layer.add(anim, forKey: "liquidGlassTransform")
        node.layer.transform = transform
    }

    enum Timing { case easeIn; case spring(damping: CGFloat, velocity: CGFloat) }
}
