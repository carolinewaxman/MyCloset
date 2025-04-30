import Foundation

func NormalizeCategory(_ raw: String) -> String {
    let lower = raw.lowercased()
    
    let manualFixups: [String: String] = [
        "tshirt": "T-shirt",
        "shirts": "T-shirt",
        "tee": "T-shirt",
        "t shirt": "T-shirt",
        "long sleeve": "Long sleeve shirt",
        "jean": "Jeans",
        "pant" : "Pants"
    ]
    let key = lower.replacingOccurrences(of: "[a-z0-9", with: "", options: .regularExpression)
    
    return manualFixups[key] ?? raw.capitalized
}
