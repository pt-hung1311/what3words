//
//  AppUseCase.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift

protocol AppUseCaseType {
    
}

struct AppUseCase: AppUseCaseType {
    let appGateway: AppGatewayType
}
