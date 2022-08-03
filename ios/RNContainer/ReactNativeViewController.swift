import React

public class ReactNativeViewController: UIViewController {
    private let moduleName: String
    private let initialProperties: [AnyHashable: Any]?

    public override func loadView() {
        guard let bridge = ReactNativeBridge.shared.bridge else {
            fatalError("You need to start React Native in order to use ReactNativeViewController, make sure to run ReactNativeBridge.shared.start() before instantiating it.")
        }
        view = RCTRootView(bridge: bridge, moduleName: moduleName, initialProperties: initialProperties)
    }
    
    public init(moduleName: String, initialProperties: [AnyHashable: Any]? = nil) {
        self.moduleName = moduleName
        self.initialProperties = initialProperties
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
