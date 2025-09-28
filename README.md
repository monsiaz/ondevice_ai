# OnDeviceAI 🤖

**Privacy-First AI Assistant for iOS**

[![iOS](https://img.shields.io/badge/iOS-18.0+-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org/)
[![MLX](https://img.shields.io/badge/MLX-Swift-green.svg)](https://github.com/ml-explore/mlx-swift)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](#license)

> **OnDeviceAI** is a revolutionary iOS application that brings powerful AI capabilities directly to your iPhone - completely offline, completely private.

## 🌟 Key Features

### 🛡️ **Privacy-First Design**
- **100% On-Device Processing**: No data ever leaves your iPhone
- **Zero Analytics**: No tracking, no telemetry, no user profiling
- **No Account Required**: Start chatting immediately after installation
- **Offline Capable**: Full functionality without internet connection

### 🚀 **Powerful AI Models**
- Support for multiple state-of-the-art language models
- **MLX Framework Integration**: Optimized for Apple Silicon
- **Smart Model Recommendations**: Based on your device capabilities
- **Efficient Memory Management**: Automatic performance optimization

### 💫 **Exceptional User Experience**
- **Native SwiftUI Interface**: Fluid, responsive, and beautiful
- **Real-time Streaming**: See responses as they're generated
- **Smart Performance Monitoring**: Automatic thermal and memory management
- **Conversation History**: Local storage with full user control

## 📱 Screenshots

<div align="center">

### 🎬 Demo Video
[![OnDeviceAI Demo](https://img.shields.io/badge/📹_Demo_Video-Watch_Now-blue?style=for-the-badge)](Captures/ScreenRecording_09-27-2025%2015-43-17_1.MP4)

### 📱 App Screenshots

<table>
<tr>
<td><img src="Captures/IMG_5476.PNG" alt="OnDeviceAI Interface" width="200"/></td>
<td><img src="Captures/IMG_5477.PNG" alt="Chat Interface" width="200"/></td>
<td><img src="Captures/IMG_5478.PNG" alt="Model Selection" width="200"/></td>
</tr>
<tr>
<td align="center"><em>Main Chat Interface</em></td>
<td align="center"><em>Real-time Streaming</em></td>
<td align="center"><em>Model Management</em></td>
</tr>
</table>

<table>
<tr>
<td><img src="Captures/IMG_5479.PNG" alt="Settings" width="200"/></td>
<td><img src="Captures/IMG_5480.PNG" alt="Performance Monitor" width="200"/></td>
<td><img src="Captures/IMG_5481.PNG" alt="Privacy Features" width="200"/></td>
</tr>
<tr>
<td align="center"><em>App Settings</em></td>
<td align="center"><em>Performance Monitoring</em></td>
<td align="center"><em>Privacy Controls</em></td>
</tr>
</table>

<table>
<tr>
<td><img src="Captures/IMG_5482.PNG" alt="Resources View" width="200"/></td>
<td><img src="Captures/IMG_5483.PNG" alt="Legal Documentation" width="200"/></td>
<td><img src="Captures/IMG_5484.PNG" alt="Model Recommendations" width="200"/></td>
</tr>
<tr>
<td align="center"><em>Resources & Legal</em></td>
<td align="center"><em>Privacy Documentation</em></td>
<td align="center"><em>Device Optimization</em></td>
</tr>
</table>

<table>
<tr>
<td><img src="Captures/IMG_5485.PNG" alt="Advanced Features" width="300"/></td>
</tr>
<tr>
<td align="center"><em>Advanced AI Features</em></td>
</tr>
</table>

</div>

**Key Interface Features:**
- ✨ Clean, modern SwiftUI design following iOS guidelines  
- ⚡ Real-time AI response streaming with performance stats
- 🧠 Smart model management with device optimization
- 🛡️ Privacy-first controls and transparent documentation
- 📊 Intelligent performance monitoring and thermal management

## 🏗️ Architecture

### Core Components

```
OnDeviceAI/
├── 🧠 Core/                  # AI Engine & Model Management
│   ├── LocalLLM.swift       # Protocol for AI models
│   ├── MLXLLM.swift         # MLX implementation [DEMO]
│   ├── ModelManager.swift   # Model lifecycle management
│   └── PerformanceMonitor.swift # Thermal & memory monitoring
├── 🎨 Views/                 # SwiftUI Interface
│   ├── ChatView.swift       # Main conversation interface
│   ├── ChatVM.swift         # Chat view model & logic
│   └── ResourcesView.swift  # Model recommendations & legal
└── 📦 Resources/            # Bundled content & legal docs
```

### Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **UI Framework** | SwiftUI | Native iOS interface |
| **AI Engine** | MLX Swift | On-device model execution |
| **Concurrency** | Swift Async/Await | Non-blocking AI processing |
| **Storage** | iOS UserDefaults & FileManager | Local conversation storage |
| **Performance** | iOS System Frameworks | Thermal & memory monitoring |

## 🚦 Getting Started

### Prerequisites

- **Xcode 15.0+**
- **iOS 18.0+** deployment target
- **iPhone with A12+ chip** (recommended)
- **6GB+ RAM** for optimal performance

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/simonazoulay/ondeviceai.git
   cd ondeviceai
   ```

2. **Install dependencies**
   ```bash
   # MLX Swift will be automatically resolved via Swift Package Manager
   ```

3. **Open in Xcode**
   ```bash
   open OnDeviceAI.xcodeproj
   ```

4. **Build and run**
   - Select your target device
   - Press ⌘+R to build and run

### First Launch

1. **Model Download**: The app will automatically download the default Qwen 2.5 0.5B model
2. **No Setup Required**: Start chatting immediately - no account, no configuration
3. **Performance Optimization**: The app automatically optimizes based on your device

## 🔧 Configuration

### Device Performance Tiers

| Device Tier | RAM | Recommended Models | Performance |
|-------------|-----|--------------------|-------------|
| **S-Tier** | 10-12GB | SOLAR 10.7B, Gemma 2 9B | Excellent |
| **A-Tier** | 8-10GB | Llama 3.1 8B, Mistral Nemo | Very Good |
| **B-Tier** | 6-8GB | Gemma 2 2B, Phi-3 Mini | Good |
| **C-Tier** | 4-6GB | Qwen 2.5 0.5B, TinyLlama | Basic |

*Your device tier is automatically detected and optimal models are recommended.*

### Performance Settings

```swift
// Automatic performance optimization based on:
- Device thermal state
- Available memory
- CPU usage
- Battery level
```

## 🏆 Why OnDeviceAI?

### **Privacy** 🛡️
Unlike cloud-based AI assistants, OnDeviceAI ensures your conversations never leave your device. No servers, no data collection, no privacy concerns.

### **Performance** ⚡
Built specifically for iOS with native optimizations:
- **Metal Performance Shaders** for GPU acceleration
- **Neural Engine** utilization when available
- **Smart memory management** prevents device overheating
- **Background processing** for seamless user experience

### **Innovation** 🚀
Leveraging Apple's MLX framework for cutting-edge on-device AI:
- **State-of-the-art models** running locally
- **Real-time streaming** responses
- **Advanced tokenization** and prompt engineering
- **Continuous performance monitoring**

## 🛠️ Development

### Project Structure

This repository contains a **demonstration version** of OnDeviceAI with certain implementation details abstracted for public sharing. The core architecture and interfaces are fully functional, showcasing the app's capabilities while protecting proprietary implementations.

### Key Interfaces

```swift
// Core AI Protocol
protocol LocalLLM {
    func load(modelURL: URL) throws
    func generate(prompt: String, onToken: @escaping (String) -> Void) throws
    func unload()
}

// Performance Monitoring
class PerformanceMonitor: ObservableObject {
    var shouldThrottleGeneration: Bool { /* Implementation */ }
    var statusText: String { /* Implementation */ }
}
```

### Contributing

This is a **demonstration repository**. For feature requests or technical discussions, please reach out:

**📧 Contact: [@SimonAzoulayFr](https://x.com/SimonAzoulayFr) on X/Twitter**

## 📄 Legal & Privacy

### Privacy Commitment
OnDeviceAI is built with privacy as its fundamental principle:
- ✅ **No data collection** of any kind
- ✅ **No analytics or tracking**
- ✅ **No cloud processing** 
- ✅ **Full user control** over local data
- ✅ **GDPR & CCPA compliant** by design

### Open Source Acknowledgments

OnDeviceAI leverages several open-source technologies:
- **[MLX Swift](https://github.com/ml-explore/mlx-swift)** - Apple's machine learning framework
- **[Qwen Models](https://huggingface.co/Qwen)** - Alibaba's language models
- Various community contributions to the MLX ecosystem

Full license attributions available in [LICENSES.md](LICENSES.md).

## 🌐 Web Resources

- **🆘 [Support & Help](https://simonazoulay.github.io/ondeviceai/support)** - How OnDeviceAI works
- **🚀 [Product Info](https://simonazoulay.github.io/ondeviceai)** - Features and capabilities  
- **🛡️ [Privacy Policy](https://simonazoulay.github.io/ondeviceai/privacy)** - Our privacy commitment
- **⚙️ [User Choices](https://simonazoulay.github.io/ondeviceai/choices)** - Privacy controls

## 📈 Roadmap

- [ ] **Apple Intelligence Integration** (iOS 18.1+)
- [ ] **Vision Model Support** for image understanding  
- [ ] **Advanced Code Models** for developer assistance
- [ ] **Multi-language Interface** support
- [ ] **Shortcuts Integration** for workflow automation

## 📞 Contact & Support

**Developer**: Simon Azoulay  
**X/Twitter**: [@SimonAzoulayFr](https://x.com/SimonAzoulayFr)  

For technical questions, feature requests, or general inquiries, DM me on X/Twitter for the fastest response.

---

<div align="center">
  <p><strong>OnDeviceAI</strong> - AI that respects your privacy</p>
  <p>Made with ❤️ for iOS • Built in France 🇫🇷</p>
</div>

## License

This project is proprietary software. The code in this repository is shared for **demonstration and educational purposes only**. 

- ✅ **Viewing and learning** from the code is encouraged
- ✅ **Academic research** and analysis is permitted  
- ❌ **Commercial use** is prohibited without permission
- ❌ **Redistribution** of the code is not allowed
- ❌ **Creating derivative works** requires explicit authorization

For licensing inquiries, contact [@SimonAzoulayFr](https://x.com/SimonAzoulayFr).

---

*© 2025 Simon Azoulay. All rights reserved.*
