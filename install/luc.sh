VERSION=$TIPI_INSTALL_VERSION

if [  -z "$TIPI_INSTALL_VERSION" ]; then
  if [ "$(uname)" == "Linux" ]; then
    TIPI_URL="https://github.com/tipi-build/cli/releases/download/v0.0.25/tipi-v0.0.25-linux-x86_64.zip" 
  elif [ "$(uname)" == "Darwin" ]; then
    TIPI_URL="https://github.com/tipi-build/cli/releases/download/v0.0.25/tipi-v0.0.25-macOS.zip"
  fi
else 
  if [ "$(uname)" == "Linux" ]; then
    TIPI_URL="https://github.com/tipi-build/cli/releases/download/$VERSION/tipi-$VERSION-linux-x86_64.zip" 
  elif [ "$(uname)" == "Darwin" ]; then
    TIPI_URL="https://github.com/tipi-build/cli/releases/download/$VERSION/tipi-$VERSION-macOS.zip"
  fi
fi

echo $TIPI_URL