//
//  LoginViewModel.swift
//  AuthorizationApp
//
//  Created by Admin on 12.12.2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

struct LoginViewModel {
    
    var email = Variable<String>("")
    var password = Variable<String>("")
    
    var isValid : Observable<Bool>{
        return Observable.combineLatest(email.asObservable(), password.asObservable()) { email, password in
            return self.validateEmail() && self.validatePassword()
        }
    }
    
    // MARK - validate check
    
    func validateEmail() -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@([A-Za-z0-9.-]{2,64})+\\.[A-Za-z]{2,64}"
        
        guard validateString(email.value, pattern: emailPattern) else { return false }
        return true
    }
    
    func validatePassword() -> Bool {
        let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])[A-Za-z0-9]{6,64}"
        
        guard validateString(password.value, pattern: passwordPattern) else { return false }
        return true
    }
    
    func choiceEmailMessageLabel() -> String? {
        

            if self.email.value.isEmpty == true {
                return "Это поле не может быть пустым"

            } else {
                if self.validateEmail() == false {
                    return "Не корректная почта"
                } else { return nil }
            }
    
    }
            
    func choicePasswordMessageLabel() -> String? {
        
        if password.value.isEmpty == true {
            return "Это поле не может быть пустым"
        } else {
            if validatePassword() == false {
                return "Не корректный пароль"
            } else { return nil }
        }
    }
    
    // MARK - parse and send request
    
    enum GetFriendsFailureReason: Int, Error {
        case notFound = 404
    }
    
    func fatchAllWeather() -> (Observable<[WeatherModel]>) {
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=Moscow&APPID=0955c91429f780ec1b64dacd40ab5471")
        return Observable<[WeatherModel]>.create({ observer -> Disposable in
            
            Alamofire.request(url!).responseJSON { response in
                switch response.result {
                case .success(let value):
                    
                    var weatherPosts = [WeatherModel]()
                    
                    let json = value as? [String: Any] ?? [:]
                    
                    let name = json["name"] as? String ?? "unknow"
                    let weather = json["main"] as? [String: Any] ?? [:]
                    let temp = weather["temp"] as? Double ?? 0.0
                    let humidity = weather["humidity"] as? Int ?? 0
                    let pressure = weather["pressure"] as? Int ?? 0
                    
                    weatherPosts.append(WeatherModel(name: name, temp: temp - 273.15, humidity: humidity, pressure: pressure))
                    
                    observer.onNext(weatherPosts)
                    observer.onCompleted()
                    
                case .failure(let error):
                    if let statusCode = response.response?.statusCode,
                        let reason = GetFriendsFailureReason(rawValue: statusCode)
                    {
                        observer.onError(reason)
                    }
                    observer.onError(error)
                }
            }
            
            return Disposables.create {}
        })
        
    }
    
}

extension LoginViewModel {

    func validateString(_ value: String?, pattern: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", pattern)
        return test.evaluate(with: value)
    }
    
}
