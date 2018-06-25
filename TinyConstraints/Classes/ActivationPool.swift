//
//  ActivationPool.swift
//  TinyConstraints
//
//  Created by Rinat Gabdullin on 25.06.2018.
//  Copyright © 2018 Robert-Hein Hooijmans. All rights reserved.
//

import Foundation

private var pools = [ActivationPool]()

class ActivationPool {

    private init() {

    }

    static var current: ActivationPool? {
        return pools.first
    }

    static func push() {
        pools.append(ActivationPool())
    }

    static func pop() {
        guard let pool = pools.popLast() else {
            return
        }

        pool.activate()
    }

    private var constraints = Constraints()

    func add(constraint: Constraint) {
        constraints.append(constraint)
    }

    func add(constraints: Constraints) {
        self.constraints.append(contentsOf: constraints)
    }

    func activate() {
        constraints.forEach { (constraint) in
            constraint.isActive = true
        }
    }
}

public func constraintsBatchActivation(closure: () -> Void) {
    ActivationPool.push()
    closure()
    ActivationPool.pop()
}
