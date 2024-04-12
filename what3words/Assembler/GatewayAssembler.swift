//
//  GatewayAssembler.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import UIKit
protocol GatewaysAssembler {
    func resolve() -> AppGatewayType
    func resolve() -> MovieGatewayType
}

extension GatewaysAssembler where Self: DefaultAssembler {
    func resolve() -> AppGatewayType {
        return AppGateway()
    }
    
    func resolve() -> MovieGatewayType {
        return MovieGateway()
    }
}
