import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background-light")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 0) {
                    Text(viewModel.response?.city.name ?? "")
                        .font(.largeTitle)
                        .foregroundStyle(.black)
                        .fontWeight(.medium)
                        .padding(.init(
                            top: 90,
                            leading: 0,
                            bottom: 16,
                            trailing: 0
                        ))
                    
                    ForEach(viewModel.dailyTemperatureExtremes) { item in
                        NavigationLink(
                            destination: ForecastDetailView(
                                viewModel: DetailViewModel(detailItem: item)
                            )
                        ) {
                            ListItem(forecastItem: item)
                        }
                    }
                    .frame(height: 90)
                    Spacer()
                }
                .padding(.top, 12)
            }
            .onAppear {
                viewModel.fetchForecast()
            }
            // Show an alert if there's an error
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    HomeView()
}
