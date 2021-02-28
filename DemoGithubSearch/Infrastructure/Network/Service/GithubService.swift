//
//  GithubService.swift
//  DemoGithubSearch
//
//  Created by Kinlive on 2021/2/28.
//  Copyright © 2021 Kinlive. All rights reserved.
//

import Foundation
import Moya

/** Implemented service with protocol BaseService

    Create other service inherit the DefaultService that generic type to conform **Moya.TargetType**, **BaseResponseDTO**, **BaseEntities** to assign your query object, response data transfer objects and final converted domain objects
 */
class GithubService<TargetTypeT: TargetType>: BaseService {

  typealias TargetTypeBase = TargetTypeT
  typealias ReturnValueBase = (responseDTO: SearchResponseDTO?, headerField: [HeadersField], error: Error?)
  typealias CancellableBase = Cancellable

  var provider: MoyaProvider<TargetTypeT>

  required init(provider: MoyaProvider<TargetTypeT>) {
    self.provider = provider
   }

  @discardableResult
  func request(targetType: TargetTypeT, completion: @escaping (ReturnValueBase) -> Void) -> Cancellable {
    return provider.request(targetType) { (result) in
      completion(self.handle(result))
    }
  }

  private func handle(_ result: Result<Moya.Response, MoyaError>) -> ReturnValueBase {
    switch result {
    case .success(let response):
      do {
        //let jsonObject = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers)
        //let jsonPretty = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        //print(String(data: jsonPretty, encoding: .utf8) ?? "")
        let link = response.response?.headers.dictionary["Link"]
        let headers = handleHeaderField(of: link)

        return (try response.map(SearchResponseDTO.self), headers, nil)

      } catch let error { return (nil, [], error) }

    case .failure(let moyaError):
      return (nil, [], moyaError)
    }
  }

  private func handleHeaderField(of link: String?) -> [HeadersField] {
    guard let link = link else { return [] }

    let urls = link
      .split(separator: ",")
      .compactMap {
        String($0)
          .replacingOccurrences(of: "<", with: "")
          .replacingOccurrences(of: ">", with: "")
          .replacingOccurrences(of: " ", with: "")
          .replacingOccurrences(of: ";", with: "&")
          .replacingOccurrences(of: "\"", with: "")
          .split(separator: "?")
          .last
      }
      .map {
        String($0)
          .split(separator: "&")
          .map { String($0) }
      }

    var dicArr: [[String: Any]] = []

    urls.forEach { infos in
      var dic: [String : Any] = [:]

      infos.forEach { tag in
        let splited = tag
          .split(separator: "=")
          .map { String($0) }

        let key = splited[0]
        let value = splited[1]

        dic[key] = value
      }
      dicArr.append(dic)
    }

   // print(urls)
   // print(dicArr)

    return dicArr
      .compactMap { dic -> HeadersField? in
        guard
          let page = (dic["page"] as? NSString)?.integerValue,
          let perPage = (dic["per_page"] as? NSString)?.integerValue,
          let q = dic["q"] as? String,
          let rel = dic["rel"] as? String,
          let relType = HeadersField.Rel(rawValue: rel)
          else { return nil }

        return HeadersField(
          text: q,
          perPage: perPage,
          page: page,
          rel: relType
        )
      }
  }
}
