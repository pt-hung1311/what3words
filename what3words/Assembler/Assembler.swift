//
//  Assembler.swift
//  what3words
//
//  Created by Hùng Phạm on 10/4/24.
//

protocol Assembler: AnyObject,
                    GatewaysAssembler,
                    CoreDataAssembler,
                    TrendingAssembler,
                    SearchAssembler,
                    DetailAssembler,
                    AppAssembler {
    
}

final class DefaultAssembler: Assembler {
    
}
