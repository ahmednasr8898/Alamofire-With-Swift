//
//  APIServices.swift
//  AlamofireDemo
//
//  Created by Ahmed Nasr on 11/25/20.
//
import Foundation
import Alamofire

class APIServices{
    class func connectWithServer<T: Decodable>(url: String , method: HTTPMethod , parameters: Parameters?,encoding:
        ParameterEncoding ,headers: HTTPHeaders? , complation: @escaping (T?, Error?)-> Void){
            
            AF.request(url , method: method , parameters: parameters, encoding: encoding ,headers: headers).responseJSON { (response) in
                
                switch response.result{
                case .failure(let error):
                    complation(nil, error)
                case .success(_):
                    guard let data = response.data else {return}
                    do{
                        let json = try JSONDecoder().decode(T.self, from: data)
                        complation(json , nil)
                    }catch let jsonError{
                        print("error when get Data: \(jsonError)")
                        complation(nil , jsonError)
                }
            }
        }
    }
}

