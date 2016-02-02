Pod::Spec.new do |s|
  s.name         = "BFWControls"
  s.version      = "1.1.0"
  s.summary      = "Common and interesting visual elements and controls."
  s.description  = <<-DESC
		Common and interesting visual elements and controls.
        Companion for BFWDrawView.
                   DESC
  s.homepage     = "https://github.com/BareFeetWare/BFWControls"
  s.license      = { :type => "MIT", :text => <<-LICENSE
        Copyright (c) 2015 BareFeetWare

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
                 LICENSE
             }
  s.authors      = { "Tom Brodhurst-Hill" => "developer@barefeetware.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/BareFeetWare/BFWControls.git", :tag => "#{s.version}" }

  s.requires_arc = true

  s.default_subspec = "All"

  s.subspec "Submodules" do |ss|
    ss.source_files = "Submodules/**/*.{h,m}"
  end

  s.subspec "All" do |ss|
    ss.dependency "BFWControls/Submodules"
    ss.dependency "BFWControls/Blur"
    ss.dependency "BFWControls/NibView"
    ss.dependency "BFWControls/Segues"
  end

  s.subspec "Blur" do |ss|
    ss.dependency "BFWControls/Submodules"
    ss.source_files = "BFWControls/Modules/Blur/**/*.{h,m}"
  end

  s.subspec "NibView" do |ss|
    ss.dependency "BFWControls/Submodules"
    ss.source_files = "BFWControls/Modules/NibView/**/*.{h,m}"
  end

  s.subspec "Segues" do |ss|
    ss.dependency "BFWControls/Submodules"
    ss.dependency "BFWControls/NibView"
    ss.source_files = "BFWControls/Modules/Segues/**/*.{h,m}"
  end
end
