import UIKit
import WebKit

final class MainViewController: UIViewController {

  private let settingsButton = UIButton(type: .system)
  private let inputUrl = UITextField()
  private let goButton = UIButton(type: .system)
  private let webView: WKWebView = {
    let webConfiguration = WKWebViewConfiguration()
    return WKWebView(frame: .zero, configuration: webConfiguration)
  }()

  private let storage = UserDefaultsStorage()
  private var divProProvider: DivProProvider!

  override func viewDidLoad() {
    super.viewDidLoad()

    divProProvider = DivProProvider(storage: storage)

    settingsButton.setImage(UIImage(named: "Settings"), for: .normal)
    settingsButton.addTarget(self, action: #selector(openSettings(_:)), for: .touchUpInside)
    settingsButton.contentHorizontalAlignment = .center

    inputUrl.text = defaultUrl
    inputUrl.borderStyle = .roundedRect
    inputUrl.keyboardType = .URL
    inputUrl.returnKeyType = .go
    inputUrl.delegate = self

    goButton.setTitle("Go", for: .normal)
    goButton.addTarget(self, action: #selector(goOnUrl(_:)), for: .touchUpInside)
    goButton.contentHorizontalAlignment = .center

    webView.load(URLRequest(url: URL(string: defaultUrl)!))

    view.addSubview(settingsButton)
    view.addSubview(inputUrl)
    view.addSubview(goButton)
    view.addSubview(webView)
  }

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    divProProvider.get().onStart()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    let frame = view.bounds.inset(by: view.safeAreaInsets)
    let buttonSize = 48.0

    settingsButton.frame = CGRect(
      x: frame.minX,
      y: frame.minY,
      width: buttonSize,
      height: buttonSize
    )
    goButton.frame = CGRect(
      x: frame.maxX - buttonSize,
      y: frame.minY,
      width: buttonSize,
      height: buttonSize
    )
    inputUrl.frame = CGRect(
      x: settingsButton.frame.maxX,
      y: frame.minY,
      width: frame.width - 2 * buttonSize,
      height: buttonSize
    )
    webView.frame = CGRect(
      x: frame.minX,
      y: frame.minY + buttonSize,
      width: frame.width,
      height: frame.height - buttonSize
    )
  }

  @objc private func openSettings(_: UIButton) {
    let controller = SettingsViewController(
      divProProvider: divProProvider,
      storage: storage
    )
    present(controller, animated: true) { [weak self] in
      self?.divProProvider.get().onEvent(openSettingsEventId)
    }
  }

  @objc private func goOnUrl(_: UIButton) {
    guard let textUrl = inputUrl.text,
          !textUrl.isEmpty,
          let url = URL(string: textUrl) else {
      return
    }
    view.endEditing(true)
    divProProvider.get().onUrl(url)
    webView.load(URLRequest(url: url))
  }
}

extension MainViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    goOnUrl(goButton)
    return true
  }
}

private let defaultUrl = "https://wikipedia.org"
private let openSettingsEventId = "settings"
