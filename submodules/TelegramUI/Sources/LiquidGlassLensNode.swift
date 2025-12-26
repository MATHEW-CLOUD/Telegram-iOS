
import UIKit
import AsyncDisplayKit
import Display

/// A self-contained “glass” lens that snapshots only its own content and blurs it.
/// No backdrop blur. No CoreImage. Uses FastBlur bridge + layer transforms (for animation).
final class LiquidGlassLensNode: ASDisplayNode {

    private let contentNode: ASDisplayNode
    private let imageNode = ASImageNode()
    private var highlighted: Bool = false

    init(content: ASDisplayNode) {
        self.contentNode = content
        super.init()
        self.isLayerBacked = true
        self.addSubnode(self.imageNode)
        self.addSubnode(self.contentNode)
    }

    override func layout() {
        super.layout()
        self.contentNode.frame = self.bounds
        self.imageNode.frame = self.bounds
    }

    /// Snapshots ONLY the lens’s own contentNode, then FastBlur.
    func refresh() {
        guard let view = self.contentNode.viewIfLoaded else { return }
        let scale = UIScreen.main.scale
        let size = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        if let ctx = UIGraphicsGetCurrentContext() {
            view.layer.render(in: ctx)
        }
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let snapshot = snapshot, let blurred = TGLiquidGlassFastBlurImage(snapshot) {
            self.imageNode.image = blurred
        }
    }

    func setHighlighted(_ value: Bool, animated: Bool) {
        self.highlighted = value
        let targetAlpha: CGFloat = value ? 0.85 : 1.0
        if animated {
            ASDisplayNode.performWithoutAnimation {
                self.imageNode.alpha = targetAlpha
            }
        } else {
            self.imageNode.alpha = targetAlpha
        }
    }
}
