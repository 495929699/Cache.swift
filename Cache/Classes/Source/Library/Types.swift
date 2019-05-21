#if os(iOS) || os(tvOS)
  import UIKit
  public typealias Image = UIImage
#elseif os(watchOS)

#elseif os(OSX)
  import AppKit
  public typealias Image = NSImage
#endif


/// 缓存结果
public typealias Result<T> = Swift.Result<T,Error>
