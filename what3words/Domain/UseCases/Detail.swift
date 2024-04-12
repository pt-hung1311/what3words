//
//  Detail.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

import RxSwift

protocol GettingDetailMovie {
    var movieGateway: MovieGatewayType { get }
}

extension GettingDetailMovie {
    func getDetailMovie(id: Int) -> Observable<Movie> {
        movieGateway.getDetailMovie(id: id)
    }
}
