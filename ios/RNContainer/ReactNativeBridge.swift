import React

public class ReactNativeBridge: NSObject {
    public static let shared = ReactNativeBridge()
    public private(set) var bridge: RCTBridge?
    public private(set) var useLocalNodeServer: Bool = false
  
    public func start(useLocalNodeServer: Bool = false, launchOptions: [AnyHashable: Any] = [:]) {
        guard self.bridge == nil else { return }
        self.useLocalNodeServer = useLocalNodeServer
        self.bridge = RCTBridge(delegate: self, launchOptions: launchOptions)
    }
}

extension ReactNativeBridge: RCTBridgeDelegate {
    public func sourceURL(for bridge: RCTBridge!) -> URL! {
        if useLocalNodeServer {
            if let url = RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index") {
                return url
            } else {
                return URL(string: "http://localhost:8081/index.bundle?platform=ios&dev=true&minify=false")!
            }
        } else {
            let bundle = Bundle(for: ReactNativeBridge.self)
            guard let url = bundle.url(forResource: "main", withExtension: "jsbundle") else {
                fatalError("Could not get url for bundle in main package")
            }
            return url
        }
    }
}
