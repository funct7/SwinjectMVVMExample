//
//  Network.swift
//  SwinjectMVVMExample
//
//  Created by Yoichi Tagaya on 8/22/15.
//  Copyright © 2015 Swinject Contributors. All rights reserved.
//

import ReactiveSwift
import Alamofire

public final class Network: Networking {
    private let queue = DispatchQueue(label: "SwinjectMMVMExample.ExampleModel.Network.Queue", attributes: [])

    public init() { }
    
    public func requestJSON(_ url: String, parameters: [String : AnyObject]?) -> SignalProducer<Any, NetworkError> {
        return SignalProducer { observer, disposable in
            AF.request(url, method: .get, parameters: parameters)
                .responseJSON(queue: self.queue) { response in
                    switch response.result {
                    case .success(let value):
                        observer.send(value: value)
                        observer.sendCompleted()
                    case .failure(let error):
                        observer.send(error: NetworkError(error: error as NSError))
                    }
                }
        }
    }
    
    public func requestImage(_ url: String) -> SignalProducer<UIImage, NetworkError> {
        return SignalProducer { observer, disposable in
            AF.request(url, method: .get)
                .responseData(queue: self.queue) { response in
                    switch response.result {
                    case .success(let data):
                        guard let image = UIImage(data: data) else {
                            observer.send(error: NetworkError.IncorrectDataReturned)
                            return
                        }
                        observer.send(value: image)
                        observer.sendCompleted()
                    case .failure(let error):
                        observer.send(error: NetworkError(error: error as NSError))
                    }
            }
        }
    }
}
