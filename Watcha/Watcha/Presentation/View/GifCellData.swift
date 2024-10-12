//
//  GifCellData.swift
//  Watcha
//
//  Created by hwikang on 10/12/24.
//

import Foundation

public enum Section: Hashable {
    case main
    case carousel
    case grid
}

public enum CellData: Hashable {
    
    case gifCell(GIFData)
}
