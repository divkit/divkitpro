import Foundation

final class UserDefaultsStorage {
  private let userDefaults: UserDefaults

  init(userDefaults: UserDefaults = .standard) {
    self.userDefaults = userDefaults
  }

  var serverURL: String {
    get {
      userDefaults.string(forKey: keyServerUrl) ?? defaultServerUrl
    }
    set {
      set(value: newValue, forKey: keyServerUrl)
    }
  }

  var appKey: String {
    get {
      userDefaults.string(forKey: keyAppKey) ?? ""
    }
    set {
      set(value: newValue, forKey: keyAppKey)
    }
  }

  private func set(value: String, forKey: String) {
    userDefaults.set(value, forKey: forKey)
    userDefaults.synchronize()
  }
}

private let defaultServerUrl = "https://api.divkit.pro/v1/publications/"

private let keyServerUrl = "keyServerUrl"
private let keyAppKey = "keyAppKey"
