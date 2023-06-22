import Foundation
import DivKitPro

final class DivProProvider {
  private let storage: UserDefaultsStorage
  private var divPro: DivPro?

  init(
    storage: UserDefaultsStorage
  ) {
    self.storage = storage
  }
  
  func get() -> DivPro {
    if let divPro = divPro {
      return divPro
    }
    let divPro = DivPro(params: makeParams())
    self.divPro = divPro
    return divPro
  }

  func resetIfNeeded() {
    let newParams = makeParams()
    guard let divPro = divPro, divPro.params != newParams else {
      return
    }
    self.divPro = DivPro(params: makeParams())
  }

  func requestData() {
    self.divPro = DivPro(params: makeParams())
  }

  private func makeParams() -> DivProParams {
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    return DivProParams(
      appKey: storage.appKey,
      appVersion: appVersion,
      flags: ["one", "two"],
      url: storage.serverURL
    )
  }
}
