# Watch

# 프로젝트 설명

### 기술 스택

Modern Concurrency, Modern CollectionView, URLSession

Combine, UserDefault, NSCache 

Modern Concurrency 를 통해 비동기적인 API응답을 핸들링 하였습니다.

Modern CollectionView 을 활용하여 다양한 레이아웃을 구현했습니다

Combine 를 활용하여 UI 로직을 구현했습니다

## 프로젝트 구성

Clean Architecture 구조의 MVVM 패턴을 활용 하여 프로젝트를 구성했습니다.

Presentation , Domain, Data 레이어로 구분되어있고

Presentation → Domin ← Data 단방향 의존성 관리되어있습니다.

### Domain

Usecase, RepositoryProtocol, Entity 로 구성됩니다.

Entity - 네트워크 응답을 객체하였고 에러 타입을 담은 NetworkError  이 포함됩니다.

Usecase - Repository 메소드를 호출하는 핵심 비즈니스 로직을 담당합니다.

저수준 모듈 Data 에 의존하지 않기 위해 RepositoryProtocol (추상화 인터페이스) 를 사용, 의존 하였습니다.

### Data

Network UseDefaults Repository 로 구성됩니다.

Network - http 네트워크 호출 담당 API 구현했으며 NetworkManager를 사용하여 중복되는 코드를 줄이고 여러 네트워크 호출에 활용됩니다.

```jsx
 func fetchData<T: Decodable>(urlString: String, httpMethod: HTTPMethod, headers: [String: String]?, queryParams: [String: Any]?) async -> Result<T,NetworkError>
```

UseDefaults - UseDefaults 통해 즐겨찾기 목록을 저장합니다.

Repository - Network, UseDefaults를 활용하여 원하는 데이터를 리턴해줍니다.

### Presentation

UI 부분을 담당하는 ViewController, ViewModel 이 있습니다.

MVVM 패턴으로 구성되었고 VM ←VC 간의 이벤트는 Input (VC→VM) Output(VM→VC) 로 정의되었습니다

```jsx

struct Input {
        let addFavorite: AnyPublisher<String, Never>
        let deleteFavorite: AnyPublisher<String, Never>
        let searchText: AnyPublisher<String,Never>
        let loadMore: AnyPublisher<Void,Never>
    }
    struct Output {
        let cellData: AnyPublisher<NSDiffableDataSourceSnapshot<Section, CellData>, Never>
        let errorMessage: AnyPublisher<String,Never>
        
    }
```

Compositional Layout Section은 세가지 타입으로 구분되며 CellData를 Item으로 사용됩니다

```jsx

public enum Section: Hashable {
    case main
    case carousel
    case grid
}
public enum CellData: Hashable {
    
    case gifCell(GIFData)
    
}

```

ViewModel에서 Snapshot을 구성하여 VC에 전달합니다

```jsx
let cellData = gifDataList
            .dropFirst()
            .map { dataList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, CellData>()
            snapshot.appendSections([.main, .carousel, .grid])
            dataList.enumerated().forEach { index, data in
                let cellData = CellData.gifCell(data)
                if index == 0 {
                    snapshot.appendItems([cellData], toSection: .main)
                } else if 1..<11 ~= index {
                    snapshot.appendItems([cellData], toSection: .carousel)
                } else {
                    snapshot.appendItems([cellData], toSection: .grid)
                }
            }
            return snapshot
        }.eraseToAnyPublisher()

```

Extension 을 통해 Image 설정 함수를 구현했고 내부적으로 CacheManager를 사용해 캐싱하였습니다

이미지가 큰경우 압축하여 용량 제한을 걸었습니다

```jsx
 func setImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        if let cachedImage = ImageCacheManager.shared.image(forKey: url as NSURL) {
            DispatchQueue.main.async { [weak self] in
                self?.image = cachedImage
            }
            return
        }
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, let downloadedImage = UIImage(data: data) else { return }
                    var finalImage = downloadedImage
                    
                    let maxSize = 500000 //500KB
                    if data.count > maxSize {
                        let compressionRatio = CGFloat(maxSize) / CGFloat(data.count)
                        let compressionQuality = max(min(compressionRatio, 1.0), 0.1)
                        if let compressedData = downloadedImage.jpegData(compressionQuality: compressionQuality) {
                            finalImage = UIImage(data: compressedData) ?? downloadedImage
                        }
                        
                    }
                    DispatchQueue.main.async {
                        self?.image = finalImage
                    }
                    ImageCacheManager.shared.setImage(finalImage, forKey: url as NSURL)
                }.resume()
            }
        }
    }
```

APIKEY 는 Bundle통해 private하게 관리 됩니다

```jsx

import Foundation
extension Bundle {
    
    var apiKey: String? {
        guard let file = self.path(forResource: "Secret", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["APIKEY"] as? String else {
            print("API KEY를 가져오는데 실패하였습니다.")
            return nil
        }
        return key
    }
    
}

```
