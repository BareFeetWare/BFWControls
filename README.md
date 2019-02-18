# BFWControls
A framework to simplify building apps using Interface Builder.

Some useful resources:

- "Build an App Like Lego" tutorials - Steps through building an app visually, by building components, using BFWControls' NibTableViewCell. Assumes no coding or Xcode knowledge. https://medium.com/@barefeettom/build-app-lego-tutorial-1-58de8e84798d
- Video of presentation at CocoaHeads Sydney (16 minutes): http://www.barefeetware.com/presentation/20181127_CocoaHeads_Sydney.mp4
- Video of presentation at CocoaHeads New York City (18 minutes): http://www.barefeetware.com/presentation/20180809_Xcode_Lego_NYCCocoaHeads.mp4

BFWControls contains many features to simplify building apps visually, especially when using Interface Builder. Features include:
- NibReplaceable protocol with NibView, NibTableViewCell classes:
    Loading xib layouts into subclasses with no extra code.
- Adjustable protocol for UITableView:
    Sticky header and footer that remain stationery while the table scrolls.
- HidingStackView:
    A stack view that hides any subviews that have invisible contents (eg UILabel.text == nil and UIImageView.image == nil) or a UIStackView subview that has all of its subviews hidden. When a stack view has a hidden subview, it removes it from the arrangedSubviews, so the space it occupied is freed, essentially shrinking any unused space.
- UIView+NSLayoutConstraint:
    Convenient AutoLayout functions like pinToSuperviewEdges(), pinToSuperview(with inset: CGFloat)
- StaticTableViewController:
    excludedCells: easy dynamic show/hide cells and sections
- SegueHandlerType protocol:
    enum SegueIdentifier
- UIApplication:
    unwindToBackmostViewController()
- UIViewController+Unwind
    unwindToSelf()
    frontViewController
- DefaultsHandlerType protocol:
    Expose UserDefaults as named variables
