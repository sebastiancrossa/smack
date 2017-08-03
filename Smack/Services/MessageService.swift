//
//  MessageService.swift
//  Smack
//
//  Created by Sebastian Crossa on 8/2/17.
//  Copyright © 2017 Sebastian Crossa. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                // The channels are returned inside an array
                if let json = JSON(data: data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let description = item["description"].stringValue
                        let id = item["_id"].stringValue
                        
                        let channel = Channel(channelTitle: name, channelDescription: description, id: id)
                        self.channels.append(channel)
                    }
                    
                    //print(self.channels[0].channelTitle)
                    completion(true)
                }
            } else {
                debugPrint(response.result.error as Any)
                completion(true)
            }
        }
    }
    
}
