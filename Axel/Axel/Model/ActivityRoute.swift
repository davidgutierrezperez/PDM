//
//  ActivityRoute.swift
//  Axel
//
//  Created by David Gutierrez on 26/5/25.
//

import Foundation

struct ActivityRoute {
    let id: UUID
    var points: [RoutePoint]
    
    init(){
        id = UUID()
        points = []
    }
    
    init(id: UUID, points: [RoutePoint]){
        self.id = id
        self.points = points
    }
}
