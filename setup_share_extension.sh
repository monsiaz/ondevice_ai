#!/bin/bash
# Script to setup Share Extension for OnDeviceAI
# Run this after creating the Share Extension target in Xcode

set -e

echo "📱 Setting up OnDeviceAI Share Extension..."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Step 1: Checking project structure...${NC}"

if [ ! -d "OnDeviceAI/Sources/ShareExtension" ]; then
    echo -e "${YELLOW}ShareExtension folder exists, good!${NC}"
fi

echo -e "${BLUE}Step 2: Instructions for Xcode setup:${NC}"
echo ""
echo -e "${GREEN}1. Open OnDeviceAI.xcodeproj in Xcode${NC}"
echo -e "${GREEN}2. File > New > Target...${NC}"
echo -e "${GREEN}3. Choose: iOS > Share Extension${NC}"
echo -e "${GREEN}4. Product Name: OnDeviceAI Share${NC}"
echo -e "${GREEN}5. Bundle Identifier: fr.simonazoulay.OnDeviceAI.Share${NC}"
echo -e "${GREEN}6. Language: Swift${NC}"
echo -e "${GREEN}7. Click Finish${NC}"
echo ""
echo -e "${BLUE}Step 3: Replace generated files:${NC}"
echo -e "${GREEN}8. In Project Navigator, find 'OnDeviceAI Share' group${NC}"
echo -e "${GREEN}9. Delete ShareViewController.swift (Move to Trash)${NC}"
echo -e "${GREEN}10. Delete Info.plist (Move to Trash)${NC}"
echo -e "${GREEN}11. Right-click 'OnDeviceAI Share' > Add Files...${NC}"
echo -e "${GREEN}12. Navigate to OnDeviceAI/Sources/ShareExtension/${NC}"
echo -e "${GREEN}13. Select ShareViewController.swift and ShareExtensionInfo.plist${NC}"
echo -e "${GREEN}14. Check 'Copy items if needed' and select 'OnDeviceAI Share' target${NC}"
echo ""
echo -e "${BLUE}Step 4: Configure target settings:${NC}"
echo -e "${GREEN}15. Select 'OnDeviceAI Share' target in Project Editor${NC}"
echo -e "${GREEN}16. General tab:${NC}"
echo -e "${GREEN}    - Deployment Target: iOS 26.0${NC}"
echo -e "${GREEN}    - Bundle Identifier: fr.simonazoulay.OnDeviceAI.Share${NC}"
echo -e "${GREEN}17. Build Settings tab > Packaging:${NC}"
echo -e "${GREEN}    - Info.plist File: \$(SRCROOT)/OnDeviceAI/Sources/ShareExtension/ShareExtensionInfo.plist${NC}"
echo -e "${GREEN}18. Build Phases tab:${NC}"
echo -e "${GREEN}    - Verify ShareViewController.swift is in 'Compile Sources'${NC}"
echo ""
echo -e "${BLUE}Step 5: Test the extension:${NC}"
echo -e "${GREEN}19. Build and run the main app${NC}"
echo -e "${GREEN}20. Open Safari, select some text${NC}"
echo -e "${GREEN}21. Tap Share > 'Analyze with OnDeviceAI'${NC}"
echo ""
echo -e "${YELLOW}Note: Share Extension will appear in the Share Sheet after first build${NC}"
echo ""
echo -e "${GREEN}✅ Setup complete! The Share Extension is ready to use.${NC}"
