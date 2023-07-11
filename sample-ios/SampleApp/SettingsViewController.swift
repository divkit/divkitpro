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
  private let testSwitch = SwitcherWithTitle(title: "Test environment")

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

    testSwitch.setSwitchIsOn(storage.testEnviromnent)
    testSwitch.onChange = { [weak self] isOn in
      self?.storage.testEnviromnent = isOn
      self?.divProProvider.resetIfNeeded()
    }

    requestButton.setTitle("Request data", for: .normal)
    requestButton.addTarget(self, action: #selector(requestData(_:)), for: .touchUpInside)
    requestButton.contentHorizontalAlignment = .left

    view.addSubview(settingsLabel)
    view.addSubview(doneButton)
    view.addSubview(serverUrlLabel)
    view.addSubview(serverUrlInput)
    view.addSubview(appKeyLabel)
    view.addSubview(appKeyInput)
    view.addSubview(testSwitch)
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
    testSwitch.frame = CGRect(
      x: positionX,
      y: appKeyInput.frame.maxY + 20,
      width: frame.width - 40,
      height: 30
    )
    requestButton.frame = CGRect(
      x: positionX,
      y: testSwitch.frame.maxY + 20,
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

private class SwitcherWithTitle: UIView {
  var onChange: ((Bool) -> Void)? = nil
  private let switcher = UISwitch()
  private let label: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0
    label.textAlignment = .left
    return label
  }()

  init(
    title: String
  ) {
    super.init(frame: .zero)

    label.text = title
    switcher.addTarget(self, action: #selector(self.switchStateDidChange(_:)), for: .valueChanged)

    addSubview(label)
    addSubview(switcher)
  }

  func setSwitchIsOn(_ value: Bool) {
    switcher.isOn = value
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    label.frame = CGRect(
      x: bounds.minX,
      y: bounds.minY,
      width: bounds.width - 60,
      height: 30
    )
    switcher.frame = CGRect(
      x: bounds.maxX - 60,
      y: bounds.minY,
      width: 60,
      height: 30
    )
  }

  @objc func switchStateDidChange(_ sender: UISwitch!) {
    guard let onChange = onChange else {
      return
    }
    onChange(sender.isOn)
  }
}
