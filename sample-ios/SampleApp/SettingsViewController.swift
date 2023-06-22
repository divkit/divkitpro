import Foundation
import UIKit

final class SettingsViewController: UIViewController {
  private let divProProvider: DivProProvider
  private let storage: UserDefaultsStorage

  private let settingsLabel = UILabel()
  private let doneButton = UIButton(type: .system)
  private let serverUrlLabel = UILabel()
  private let serverUrlInput = UITextField()
  private let appKeyLabel = UILabel()
  private let appKeyInput = UITextField()
  private let requestButton = UIButton(type: .system)

  init(
    divProProvider: DivProProvider,
    storage: UserDefaultsStorage
  ) {
    self.divProProvider = divProProvider
    self.storage = storage

    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    settingsLabel.text = "Settings"
    settingsLabel.textAlignment = .center
    settingsLabel.font = UIFont.boldSystemFont(ofSize: 16.0)

    doneButton.setTitle("Done", for: .normal)
    doneButton.addTarget(self, action: #selector(tapDone(_:)), for: .touchUpInside)
    doneButton.contentHorizontalAlignment = .center

    serverUrlLabel.text = "Server url:"
    appKeyLabel.text = "App key:"

    serverUrlInput.text = storage.serverURL
    serverUrlInput.borderStyle = .roundedRect
    serverUrlInput.addTarget(self, action: #selector(serverUrlDidChange(_:)), for: .editingChanged)
    serverUrlInput.keyboardType = .URL
    serverUrlInput.returnKeyType = .done
    serverUrlInput.delegate = self

    appKeyInput.text = storage.appKey
    appKeyInput.borderStyle = .roundedRect
    appKeyInput.addTarget(self, action: #selector(appKeyDidChange(_:)), for: .editingChanged)
    appKeyInput.returnKeyType = .done
    appKeyInput.delegate = self

    requestButton.setTitle("Request data", for: .normal)
    requestButton.addTarget(self, action: #selector(requestData(_:)), for: .touchUpInside)
    requestButton.contentHorizontalAlignment = .left

    view.addSubview(settingsLabel)
    view.addSubview(doneButton)
    view.addSubview(serverUrlLabel)
    view.addSubview(serverUrlInput)
    view.addSubview(appKeyLabel)
    view.addSubview(appKeyInput)
    view.addSubview(requestButton)

    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tapRecognizer.cancelsTouchesInView = false
    view.addGestureRecognizer(tapRecognizer)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    let frame = view.bounds.inset(by: view.safeAreaInsets)
    let positionX = frame.minX + 20

    settingsLabel.frame = CGRect(
      x: 80,
      y: frame.minY,
      width: frame.width - 160,
      height: 60
    )
    doneButton.frame = CGRect(
      x: frame.width - 80,
      y: frame.minY,
      width: 80,
      height: 60
    )
    serverUrlLabel.frame = CGRect(
      x: positionX,
      y: settingsLabel.frame.minY + 40,
      width: frame.width - 40,
      height: 30
    )
    serverUrlInput.frame = CGRect(
      x: positionX,
      y: serverUrlLabel.frame.maxY + 5,
      width: frame.width - 40,
      height: 30
    )
    appKeyLabel.frame = CGRect(
      x: positionX,
      y: serverUrlInput.frame.maxY + 20,
      width: frame.width - 40,
      height: 30
    )
    appKeyInput.frame = CGRect(
      x: positionX,
      y: appKeyLabel.frame.maxY + 5,
      width: frame.width - 40,
      height: 30
    )
    requestButton.frame = CGRect(
      x: positionX,
      y: appKeyInput.frame.maxY + 20,
      width: frame.width - 40,
      height: 30
    )
  }

  @objc func dismissKeyboard() {
    divProProvider.resetIfNeeded()
    view.endEditing(true)
  }

  @objc func tapDone(_: UIButton) {
    divProProvider.resetIfNeeded()
    dismiss(animated: true)
  }

  @objc func requestData(_: UIButton) {
    divProProvider.requestData()
  }

  @objc private func serverUrlDidChange(_: UITextField) {
    storage.serverURL = serverUrlInput.text ?? ""
  }
  
  @objc private func appKeyDidChange(_: UITextField) {
    storage.appKey = appKeyInput.text ?? ""
  }
}

extension SettingsViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    dismissKeyboard()
    return true
  }
}
