import Foundation
import BasePublic

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

  var testEnviromnent: Bool {
    get {
      userDefaults.bool(forKey: keyTestEnviromnent) 
    }
    set {
      set(value: newValue, forKey: keyTestEnviromnent)
    }
  }

  private func set<T: KeyValueDirectStoringSupporting>(value: T, forKey: String) {
      userDefaults.set(value, forKey: forKey)
      userDefaults.synchronize()
  }
}

private let defaultServerUrl = "https://api.divkit.pro/v1/publications/"

private let keyServerUrl = "keyServerUrl"
private let keyAppKey = "keyAppKey"
private let keyTestEnviromnent = "keyTestEnviromnent"
