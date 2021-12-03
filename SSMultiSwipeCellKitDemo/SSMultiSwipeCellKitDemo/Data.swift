//
//  DummyData.swift
//  SSMultiSwipeCellKitDemo
//
//  Created by Nishchal Visavadiya on 26/11/21.
//

import Foundation


class Data {
    
    let mainTitle: String
    let subTitle: String
    let descripttion: String
    let imageUrlString: String
    
    init(mainTitle: String, subTitle: String, description: String, imageUrlString: String) {
        self.mainTitle = mainTitle
        self.subTitle = subTitle
        self.descripttion = description
        self.imageUrlString = imageUrlString
    }
    
    static let quote1 = Data(mainTitle: "Lorem", subTitle: "Ipsum", description: "Lorem ipsum dolor sit amet, sed do eiusmod tempor incididunt.", imageUrlString: "https://image.freepik.com/free-vector/mysterious-mafia-man-smoking-cigarette_52683-34828.jpg")
    
    static let quotes = [
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1,
        quote1
    ]
    
}
