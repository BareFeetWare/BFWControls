#
#  Be sure to run `pod spec lint BFWControls.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "BFWControls"
  s.version      = "3.0.2"
  s.summary      = "A framework to simplify building apps using Interface Builder."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description  = <<-DESC
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
                   DESC

  s.homepage     = "https://bitbucket.org/BareFeetWare/BFWControls"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  # s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "License.md" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Tom Brodhurst-Hill" => "developer@barefeetware.com" }
  # Or just: s.author    = "Tom Brodhurst-Hill"
  # s.authors            = { "Tom Brodhurst-Hill" => "developer@barefeetware.com" }
  s.social_media_url   = "http://twitter.com/barefeetware"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios

  s.platform     = :ios, "9.0"
  s.swift_version = "4.2"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/BareFeetWare/BFWControls.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  #s.source_files  = "Classes", "Classes/**/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"

  s.source_files  = "BFWControls", "BFWControls/**/*.{swift,h,m}"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
