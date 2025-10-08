import Foundation

enum TravelError: Error {
    case invalidURL
    case networkError
    case decodingError
}

struct TravelDataService {
    static func fetchTravelInfo(for city: String) async throws -> String {
        // 使用政府開放資料平台的 API
        guard let url = URL(string: "https://media.taiwan.net.tw/XMLReleaseALL_public/scenic_spot_C_f.json") else {
            throw TravelError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // 解碼 JSON 數據
        if let decodedResponse = try? JSONDecoder().decode(TravelResponse.self, from: data) {
            // 篩選台北市的景點
            let taipeiSpots = decodedResponse.XML_Head.Infos.Info.filter {
                $0.Region == "臺北市"
            }
            
            // 格式化輸出
            var result = "推薦景點：\n\n"
            for spot in taipeiSpots.prefix(5) {
                result += "🏛 \(spot.Name)\n"
                result += "📍 地址：\(spot.Add)\n"
                if !spot.Tel.isEmpty {
                    result += "☎️ 電話：\(spot.Tel)\n"
                }
                if !spot.Toldescribe.isEmpty {
                    result += "📝 簡介：\(spot.Toldescribe)\n"
                }
                result += "\n"
            }
            
            return result
        } else {
            throw TravelError.decodingError
        }
    }
}

// JSON 解碼結構
struct TravelResponse: Codable {
    let XML_Head: XMLHead
}

struct XMLHead: Codable {
    let Infos: Infos
}

struct Infos: Codable {
    let Info: [TravelSpot]
}

struct TravelSpot: Codable {
    let Name: String
    let Region: String
    let Add: String
    let Tel: String
    let Toldescribe: String
} 
