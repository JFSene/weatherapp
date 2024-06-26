import SwiftUI
import Combine

class DetailViewModel: ObservableObject {
    @Published var detailItem: HomeModel
    
    init(detailItem: HomeModel) {
        self.detailItem = detailItem
    }
}
