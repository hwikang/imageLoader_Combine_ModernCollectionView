//
//  NetworkError.swift
//  Watcha
//
//  Created by hwikang on 10/11/24.
//

import Foundation

public enum NetworkError: Error {
    case urlError(String)
    case invalidQueryParams
    case invalid
    case failToDecode(String)
    case dataNil
    case serverError(Int)
    case requestFailed(String)
    case encodingError
    public var description: String {
        switch self {
        case .urlError(let url): return "URL 이 올바르지 않습니다. \(url)"
        case .invalidQueryParams:  return "쿼리 파라미터가 유효하지 않습니다"
        case .dataNil: return "데이터가 없습니다."
        case .failToDecode(let message): return "디코딩 에러 \(message)"
        case .invalid: return "유효하지 않습니다."
        case .serverError(let code): return "서버 에러 \(code)"
        case .requestFailed(let message): return "서버 요청 실패 \(message)"
        case .encodingError: return "인코딩 실패"
        }
    }
}
