//
//  Observation.swift
//  BFWControls
//
//  Created by Tom Brodhurst-Hill on 24/1/18.
//  Copyright © 2018 BareFeetWare. All rights reserved.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//

public struct Observation {
    let observer: Observer
    let keyPath: String
}

//public protocol Observer {
//    func didSet(observable: Observable, keyPath: String)
//}

public protocol Observable {
    var observations: [Observation] { get set }
}

public extension Observable {
    func observe(_ keyPath: String, action: ((String, Any) -> Void)) {
        
    }
    public mutating func add(observer: Observer, keyPath: String) {
        let observation = Observation(observer: observer, keyPath: keyPath)
        observations.append(observation)
    }
    
    public func notifyObservers(ofChangeTo keyPath: String) {
        observations
            .filter { $0.keyPath == keyPath }
            .forEach { $0.observer.didSet(observable: self, keyPath: keyPath) }
    }
}
